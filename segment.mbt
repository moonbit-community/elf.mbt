///|
/// Lazy table of ELF program headers.
///
/// Program headers describe segments used by loaders. The table stores a raw
/// byte range and parses `ProgramHeader` entries only on demand.
pub struct SegmentTable {
  table : ParsingTable[ProgramHeader]
}

///|
fn SegmentTable::SegmentTable(
  endian : Endian,
  class : Class,
  data : BytesView,
) -> SegmentTable {
  {
    table: ParsingTable(
      endian,
      class,
      data,
      ProgramHeader::size_for(class),
      ProgramHeader::parse_at,
    ),
  }
}

///|
/// Number of program headers in the table.
pub fn SegmentTable::len(self : SegmentTable) -> Int {
  self.table.len()
}

///|
/// Returns `true` when the file has no program headers.
pub fn SegmentTable::is_empty(self : SegmentTable) -> Bool {
  self.table.is_empty()
}

///|
/// Parse the program header at `index`.
pub fn SegmentTable::get(
  self : SegmentTable,
  index : Int,
) -> ProgramHeader raise ParseError {
  self.table.get(index)
}

///|
/// Iterate over program headers, parsing each header lazily.
pub fn SegmentTable::iter(self : SegmentTable) -> Iter[ProgramHeader] {
  self.table.iter()
}

///|
/// ELF program header normalized across ELF32 and ELF64 layouts.
///
/// Program headers identify the file ranges and memory ranges used by the
/// runtime loader. Width-dependent ELF32 fields are widened to `UInt64`.
pub(all) struct ProgramHeader {
  /// Segment type such as `PT_LOAD`, `PT_DYNAMIC`, or `PT_NOTE`.
  p_type : UInt
  /// File offset where this segment starts.
  p_offset : UInt64
  /// Virtual address where the segment should be loaded.
  p_vaddr : UInt64
  /// Physical address, meaningful only for systems that use it.
  p_paddr : UInt64
  /// Number of bytes occupied by this segment in the file.
  p_filesz : UInt64
  /// Number of bytes occupied by this segment in memory.
  p_memsz : UInt64
  /// Segment permission and processor flags (`PF_*`).
  p_flags : UInt
  /// File and memory alignment requirement.
  p_align : UInt64
} derive(Debug, Eq)

///|
impl ParseAt for ProgramHeader with parse_at(endian, class, offset, data) {
  let end = checked_add(offset, ProgramHeader::size_for(class))
  let record = slice_checked(data, offset, end)
  let phdr = match (class, endian) {
    (ELF32, Little) =>
      match record {
        [
          u32le(p_type),
          u32le(p_offset32),
          u32le(p_vaddr32),
          u32le(p_paddr32),
          u32le(p_filesz32),
          u32le(p_memsz32),
          u32le(p_flags),
          u32le(p_align32),
        ] =>
          {
            p_type,
            p_offset: p_offset32.to_uint64(),
            p_vaddr: p_vaddr32.to_uint64(),
            p_paddr: p_paddr32.to_uint64(),
            p_filesz: p_filesz32.to_uint64(),
            p_memsz: p_memsz32.to_uint64(),
            p_flags,
            p_align: p_align32.to_uint64(),
          }
        _ => raise SliceReadError(offset, end)
      }
    (ELF32, Big) =>
      match record {
        [
          u32be(p_type),
          u32be(p_offset32),
          u32be(p_vaddr32),
          u32be(p_paddr32),
          u32be(p_filesz32),
          u32be(p_memsz32),
          u32be(p_flags),
          u32be(p_align32),
        ] =>
          {
            p_type,
            p_offset: p_offset32.to_uint64(),
            p_vaddr: p_vaddr32.to_uint64(),
            p_paddr: p_paddr32.to_uint64(),
            p_filesz: p_filesz32.to_uint64(),
            p_memsz: p_memsz32.to_uint64(),
            p_flags,
            p_align: p_align32.to_uint64(),
          }
        _ => raise SliceReadError(offset, end)
      }
    (ELF64, Little) =>
      match record {
        [
          u32le(p_type),
          u32le(p_flags),
          u64le(p_offset),
          u64le(p_vaddr),
          u64le(p_paddr),
          u64le(p_filesz),
          u64le(p_memsz),
          u64le(p_align),
        ] =>
          {
            p_type,
            p_offset,
            p_vaddr,
            p_paddr,
            p_filesz,
            p_memsz,
            p_flags,
            p_align,
          }
        _ => raise SliceReadError(offset, end)
      }
    (ELF64, Big) =>
      match record {
        [
          u32be(p_type),
          u32be(p_flags),
          u64be(p_offset),
          u64be(p_vaddr),
          u64be(p_paddr),
          u64be(p_filesz),
          u64be(p_memsz),
          u64be(p_align),
        ] =>
          {
            p_type,
            p_offset,
            p_vaddr,
            p_paddr,
            p_filesz,
            p_memsz,
            p_flags,
            p_align,
          }
        _ => raise SliceReadError(offset, end)
      }
  }
  (phdr, end)
}

///|
/// Size in bytes of one program header for the given ELF class.
pub fn ProgramHeader::size_for(class : Class) -> Int {
  match class {
    ELF32 => 32
    ELF64 => 56
  }
}

///|
// Convert this segment's `(p_offset, p_filesz)` pair to a checked file range.
fn ProgramHeader::get_file_data_range(
  self : ProgramHeader,
) -> (Int, Int) raise ParseError {
  let start = u64_to_int_checked(self.p_offset)
  let size = u64_to_int_checked(self.p_filesz)
  let end = checked_add(start, size)
  (start, end)
}
