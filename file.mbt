///|
/// ELF word-size class decoded from `e_ident[EI_CLASS]`.
///
/// The class determines the on-disk layout and field widths for headers,
/// symbols, relocations, and compression records.
pub(all) enum Class {
  /// 32-bit ELF layout (`ELFCLASS32`).
  ELF32
  /// 64-bit ELF layout (`ELFCLASS64`).
  ELF64
} derive(Debug, Eq)

///|
/// Parsed ELF file header.
///
/// The ELF file header identifies the file, target architecture, byte order,
/// entry point, and the locations of the program and section header tables.
/// Width-dependent fields are widened to `UInt64` where needed so callers can
/// use one type for both `ELF32` and `ELF64` inputs.
pub(all) struct FileHeader {
  /// 32-bit or 64-bit object layout.
  class : Class
  /// Byte order used by multi-byte integer fields.
  endianness : Endian
  /// ELF object version, normally `EV_CURRENT`.
  version : UInt
  /// Operating-system ABI identifier from `e_ident[EI_OSABI]`.
  osabi : Byte
  /// ABI version byte from `e_ident[EI_ABIVERSION]`.
  abiversion : Byte
  /// Object file type such as `ET_EXEC`, `ET_DYN`, or `ET_REL`.
  e_type : UInt16
  /// Target instruction-set architecture, such as `EM_X86_64`.
  e_machine : UInt16
  /// Virtual address where execution starts, or zero if there is no entry point.
  e_entry : UInt64
  /// File offset of the program header table, or zero if absent.
  e_phoff : UInt64
  /// File offset of the section header table, or zero if absent.
  e_shoff : UInt64
  /// Processor-specific file flags.
  e_flags : UInt
  /// Size of this ELF header in bytes.
  e_ehsize : UInt16
  /// Size of one program header table entry in bytes.
  e_phentsize : UInt16
  /// Number of program header entries, with `PN_XNUM` meaning extended count.
  e_phnum : UInt16
  /// Size of one section header table entry in bytes.
  e_shentsize : UInt16
  /// Number of section headers, with zero meaning an extended count in section 0.
  e_shnum : UInt16
  /// Section-header index of the section-name string table.
  e_shstrndx : UInt16
} derive(Debug, Eq)

///|
fn verify_ident(buf : BytesView) -> Unit raise ParseError {
  // The ELF identity starts with four fixed magic bytes followed by class,
  // data encoding, version, OS ABI, and padding bytes.
  let magic = slice_checked(buf, 0, EI_CLASS)
  if magic != ELFMAGIC[:] {
    raise BadMagic(magic.to_owned())
  }
  let version = buf[EI_VERSION]
  if version != EV_CURRENT {
    raise UnsupportedVersion(version.to_uint64(), EV_CURRENT.to_uint64())
  }
}

///|
fn parse_ident(
  data : BytesView,
) -> (Endian, Class, Byte, Byte) raise ParseError {
  verify_ident(data)
  let class = match data[EI_CLASS] {
    ELFCLASS32 => ELF32
    ELFCLASS64 => ELF64
    other => raise UnsupportedElfClass(other)
  }
  let endian = Endian::from_ei_data(data[EI_DATA])
  (endian, class, data[EI_OSABI], data[EI_ABIVERSION])
}

///|
fn FileHeader::parse_tail(
  ident : (Endian, Class, Byte, Byte),
  data : BytesView,
) -> FileHeader raise ParseError {
  let (endian, class, osabi, abiversion) = ident
  let size = match class {
    ELF32 => ELF32_EHDR_TAILSIZE
    ELF64 => ELF64_EHDR_TAILSIZE
  }
  let end = checked_add(0, size)
  let record = slice_checked(data, 0, end)
  let (
    e_type,
    e_machine,
    version,
    e_entry,
    e_phoff,
    e_shoff,
    e_flags,
    e_ehsize,
    e_phentsize,
    e_phnum,
    e_shentsize,
    e_shnum,
    e_shstrndx,
  ) = match (class, endian) {
    (ELF32, Little) =>
      match record {
        [
          u16le(e_type),
          u16le(e_machine),
          u32le(version),
          u32le(entry32),
          u32le(phoff32),
          u32le(shoff32),
          u32le(e_flags),
          u16le(e_ehsize),
          u16le(e_phentsize),
          u16le(e_phnum),
          u16le(e_shentsize),
          u16le(e_shnum),
          u16le(e_shstrndx),
        ] =>
          (
            e_type.to_uint16(),
            e_machine.to_uint16(),
            version,
            entry32.to_uint64(),
            phoff32.to_uint64(),
            shoff32.to_uint64(),
            e_flags,
            e_ehsize.to_uint16(),
            e_phentsize.to_uint16(),
            e_phnum.to_uint16(),
            e_shentsize.to_uint16(),
            e_shnum.to_uint16(),
            e_shstrndx.to_uint16(),
          )
        _ => raise SliceReadError(0, end)
      }
    (ELF32, Big) =>
      match record {
        [
          u16be(e_type),
          u16be(e_machine),
          u32be(version),
          u32be(entry32),
          u32be(phoff32),
          u32be(shoff32),
          u32be(e_flags),
          u16be(e_ehsize),
          u16be(e_phentsize),
          u16be(e_phnum),
          u16be(e_shentsize),
          u16be(e_shnum),
          u16be(e_shstrndx),
        ] =>
          (
            e_type.to_uint16(),
            e_machine.to_uint16(),
            version,
            entry32.to_uint64(),
            phoff32.to_uint64(),
            shoff32.to_uint64(),
            e_flags,
            e_ehsize.to_uint16(),
            e_phentsize.to_uint16(),
            e_phnum.to_uint16(),
            e_shentsize.to_uint16(),
            e_shnum.to_uint16(),
            e_shstrndx.to_uint16(),
          )
        _ => raise SliceReadError(0, end)
      }
    (ELF64, Little) =>
      match record {
        [
          u16le(e_type),
          u16le(e_machine),
          u32le(version),
          u64le(e_entry),
          u64le(e_phoff),
          u64le(e_shoff),
          u32le(e_flags),
          u16le(e_ehsize),
          u16le(e_phentsize),
          u16le(e_phnum),
          u16le(e_shentsize),
          u16le(e_shnum),
          u16le(e_shstrndx),
        ] =>
          (
            e_type.to_uint16(),
            e_machine.to_uint16(),
            version,
            e_entry,
            e_phoff,
            e_shoff,
            e_flags,
            e_ehsize.to_uint16(),
            e_phentsize.to_uint16(),
            e_phnum.to_uint16(),
            e_shentsize.to_uint16(),
            e_shnum.to_uint16(),
            e_shstrndx.to_uint16(),
          )
        _ => raise SliceReadError(0, end)
      }
    (ELF64, Big) =>
      match record {
        [
          u16be(e_type),
          u16be(e_machine),
          u32be(version),
          u64be(e_entry),
          u64be(e_phoff),
          u64be(e_shoff),
          u32be(e_flags),
          u16be(e_ehsize),
          u16be(e_phentsize),
          u16be(e_phnum),
          u16be(e_shentsize),
          u16be(e_shnum),
          u16be(e_shstrndx),
        ] =>
          (
            e_type.to_uint16(),
            e_machine.to_uint16(),
            version,
            e_entry,
            e_phoff,
            e_shoff,
            e_flags,
            e_ehsize.to_uint16(),
            e_phentsize.to_uint16(),
            e_phnum.to_uint16(),
            e_shentsize.to_uint16(),
            e_shnum.to_uint16(),
            e_shstrndx.to_uint16(),
          )
        _ => raise SliceReadError(0, end)
      }
  }
  if version != EV_CURRENT.to_uint() {
    raise UnsupportedVersion(version.to_uint64(), EV_CURRENT.to_uint64())
  }
  {
    class,
    endianness: endian,
    version,
    osabi,
    abiversion,
    e_type,
    e_machine,
    e_entry,
    e_phoff,
    e_shoff,
    e_flags,
    e_ehsize,
    e_phentsize,
    e_phnum,
    e_shentsize,
    e_shnum,
    e_shstrndx,
  }
}
