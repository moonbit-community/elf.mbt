///|
/// Parsed ELF note.
///
/// Known GNU notes are decoded into dedicated variants. Other note records are
/// preserved as `Unknown` so callers can inspect the raw owner name and
/// descriptor bytes.
pub(all) enum Note {
  /// GNU ABI tag note (`name == "GNU\0"`, `n_type == NT_GNU_ABI_TAG`).
  GnuAbiTag(NoteGnuAbiTag)
  /// GNU build ID note (`name == "GNU\0"`, `n_type == NT_GNU_BUILD_ID`).
  GnuBuildId(NoteGnuBuildId)
  /// Any note that is not recognized by this package.
  Unknown(NoteAny)
} derive(Debug, Eq)

///|
/// Contents of a GNU ABI tag note.
///
/// The version fields describe the earliest compatible kernel ABI. For
/// example, `major = 2`, `minor = 6`, `subminor = 32` means Linux 2.6.32.
pub(all) struct NoteGnuAbiTag {
  /// Operating-system code, such as `ELF_NOTE_GNU_ABI_TAG_OS_LINUX`.
  os : UInt
  /// Major kernel ABI version.
  major : UInt
  /// Minor kernel ABI version.
  minor : UInt
  /// Patch/subminor kernel ABI version.
  subminor : UInt
} derive(Debug, Eq)

///|
/// GNU build ID descriptor bytes.
///
/// The bytes are a view into the original note payload and are not interpreted
/// by the parser.
pub(all) struct NoteGnuBuildId(BytesView) derive(Debug, Eq)

///|
/// Raw representation of an ELF note the parser does not specialize.
pub(all) struct NoteAny {
  /// Note type value from the note header.
  n_type : UInt64
  /// Raw owner/name bytes, usually including a trailing NUL byte.
  name : BytesView
  /// Raw note descriptor bytes.
  desc : BytesView
} derive(Debug, Eq)

///|
/// Decode the note owner/name bytes as UTF-8 and trim trailing NUL bytes.
pub fn NoteAny::name_str(self : NoteAny) -> String raise ParseError {
  let text = @utf8.decode(self.name) catch { _ => raise Utf8Error }
  let mut end = text.length()
  while end > 0 && text[end - 1] == 0 {
    end -= 1
  }
  text[0:end].to_owned()
}

///|
struct NoteHeader {
  n_namesz : UInt64
  n_descsz : UInt64
  n_type : UInt64
} derive(Debug, Eq)

///|
impl ParseAt for NoteHeader with parse_at(endian, class, offset, data) {
  let size = match class {
    ELF32 => 12
    ELF64 => 24
  }
  let end = checked_add(offset, size)
  let record = slice_checked(data, offset, end)
  let header = match (class, endian) {
    (ELF32, Little) =>
      match record {
        [u32le(n_namesz32), u32le(n_descsz32), u32le(n_type32)] =>
          {
            n_namesz: n_namesz32.to_uint64(),
            n_descsz: n_descsz32.to_uint64(),
            n_type: n_type32.to_uint64(),
          }
        _ => raise SliceReadError(offset, end)
      }
    (ELF32, Big) =>
      match record {
        [u32be(n_namesz32), u32be(n_descsz32), u32be(n_type32)] =>
          {
            n_namesz: n_namesz32.to_uint64(),
            n_descsz: n_descsz32.to_uint64(),
            n_type: n_type32.to_uint64(),
          }
        _ => raise SliceReadError(offset, end)
      }
    (ELF64, Little) =>
      match record {
        [u64le(n_namesz), u64le(n_descsz), u64le(n_type)] =>
          { n_namesz, n_descsz, n_type }
        _ => raise SliceReadError(offset, end)
      }
    (ELF64, Big) =>
      match record {
        [u64be(n_namesz), u64be(n_descsz), u64be(n_type)] =>
          { n_namesz, n_descsz, n_type }
        _ => raise SliceReadError(offset, end)
      }
  }
  (header, end)
}

///|
impl ParseAt for NoteGnuAbiTag with parse_at(endian, _class, offset, data) {
  let end = checked_add(offset, 16)
  let record = slice_checked(data, offset, end)
  let tag = match endian {
    Little =>
      match record {
        [u32le(os), u32le(major), u32le(minor), u32le(subminor)] =>
          { os, major, minor, subminor }
        _ => raise SliceReadError(offset, end)
      }
    Big =>
      match record {
        [u32be(os), u32be(major), u32be(minor), u32be(subminor)] =>
          { os, major, minor, subminor }
        _ => raise SliceReadError(offset, end)
      }
  }
  (tag, end)
}

///|
fn align_offset(offset : Int, align : Int) -> Int raise ParseError {
  if align <= 1 {
    offset
  } else {
    let remainder = offset % align
    if remainder == 0 {
      offset
    } else {
      checked_add(offset, align - remainder)
    }
  }
}

///|
fn Note::parse_at(
  endian : Endian,
  class : Class,
  align : Int,
  offset : Int,
  data : BytesView,
) -> (Note, Int) raise ParseError {
  let align = if align == 0 { 4 } else { align }
  // ELF notes are commonly encoded with 32-bit note headers even in 64-bit objects
  let (nhdr, next) = NoteHeader::parse_at(endian, ELF32, offset, data)
  let mut idx = next
  let name_start = idx
  let name_size = u64_to_int_checked(nhdr.n_namesz)
  let name_end = checked_add(name_start, name_size)
  let name = slice_checked(data, name_start, name_end)
  idx = align_offset(name_end, align)
  let desc_start = idx
  let desc_size = u64_to_int_checked(nhdr.n_descsz)
  let desc_end = checked_add(desc_start, desc_size)
  let desc = slice_checked(data, desc_start, desc_end)
  idx = align_offset(desc_end, align)
  let note = if name == ELF_NOTE_GNU[:] && nhdr.n_type == NT_GNU_ABI_TAG {
    // GNU ABI tag descriptors contain four 32-bit words.
    let (abi_tag, _) = NoteGnuAbiTag::parse_at(endian, class, 0, desc)
    GnuAbiTag(abi_tag)
  } else if name == ELF_NOTE_GNU[:] && nhdr.n_type == NT_GNU_BUILD_ID {
    GnuBuildId(NoteGnuBuildId(desc))
  } else {
    Unknown({ n_type: nhdr.n_type, name, desc })
  }
  (note, idx)
}

///|
/// Stateful iterator over notes in a note section or note segment.
///
/// Invalid note data ends iteration. Use `ElfBytes::section_data_as_notes` or
/// `ElfBytes::segment_data_as_notes` to construct this with the correct class,
/// endian, and alignment.
pub struct NoteIterator {
  /// Byte order used for note headers and known descriptors.
  endian : Endian
  /// ELF class of the owning file.
  class : Class
  /// Alignment used between note name and descriptor payloads.
  align : Int
  /// Raw note section or segment bytes.
  data : BytesView
  /// Current byte offset in `data`.
  mut offset : Int
}

///|
/// Create a note iterator over raw note bytes.
///
/// `align` comes from `sh_addralign` for note sections or `p_align` for note
/// segments. A value of zero is treated as four-byte note alignment.
pub fn NoteIterator::new(
  endian : Endian,
  class : Class,
  align : Int,
  data : BytesView,
) -> NoteIterator {
  { endian, class, align, data, offset: 0 }
}

///|
/// Parse and return the next note, or `None` at end of data or after malformed input.
pub fn NoteIterator::next(self : NoteIterator) -> Note? {
  if self.offset >= self.data.length() {
    None
  } else {
    try
      Note::parse_at(
        self.endian,
        self.class,
        self.align,
        self.offset,
        self.data,
      )
    catch {
      _ => {
        self.offset = self.data.length()
        None
      }
    } noraise {
      (note, next) => {
        self.offset = next
        Some(note)
      }
    }
  }
}

///|
/// Convert the note iterator to a standard `Iter[Note]`.
pub fn NoteIterator::iter(self : NoteIterator) -> Iter[Note] {
  Iter::new(fn() { self.next() })
}
