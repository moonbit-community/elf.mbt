///|
/// Lazy table of ELF section headers.
///
/// The table wraps the raw section-header byte range and decodes individual
/// `SectionHeader` values only when requested.
pub struct SectionHeaderTable {
  table : ParsingTable[SectionHeader]
}

///|
fn SectionHeaderTable::SectionHeaderTable(
  endian : Endian,
  class : Class,
  data : BytesView,
) -> SectionHeaderTable {
  {
    table: ParsingTable(
      endian,
      class,
      data,
      SectionHeader::size_for(class),
      SectionHeader::parse_at,
    ),
  }
}

///|
/// Number of section headers in the table.
pub fn SectionHeaderTable::len(self : SectionHeaderTable) -> Int {
  self.table.len()
}

///|
/// Returns `true` when the file has an empty section-header table.
pub fn SectionHeaderTable::is_empty(self : SectionHeaderTable) -> Bool {
  self.table.is_empty()
}

///|
/// Parse the section header at `index`.
pub fn SectionHeaderTable::get(
  self : SectionHeaderTable,
  index : Int,
) -> SectionHeader raise ParseError {
  self.table.get(index)
}

///|
/// Iterate over section headers, parsing each header lazily.
pub fn SectionHeaderTable::iter(
  self : SectionHeaderTable,
) -> Iter[SectionHeader] {
  self.table.iter()
}

///|
/// ELF section header normalized across ELF32 and ELF64 layouts.
///
/// The field names match the System V ABI. Width-dependent ELF32 fields are
/// widened to `UInt64` where the ELF64 form uses 64 bits.
pub(all) struct SectionHeader {
  /// Offset into the section-name string table.
  sh_name : UInt
  /// Section type such as `SHT_PROGBITS`, `SHT_STRTAB`, or `SHT_DYNSYM`.
  sh_type : UInt
  /// Section flags bitmask (`SHF_*`).
  sh_flags : UInt64
  /// Virtual address where the section appears in memory, if loaded.
  sh_addr : UInt64
  /// File offset of this section's data.
  sh_offset : UInt64
  /// Size of this section's file data in bytes.
  sh_size : UInt64
  /// Section-type-specific link field, often another section index.
  sh_link : UInt
  /// Section-type-specific info field.
  sh_info : UInt
  /// Required section alignment.
  sh_addralign : UInt64
  /// Entry size when the section data is a table, or zero otherwise.
  sh_entsize : UInt64
} derive(Debug, Eq)

///|
impl ParseAt for SectionHeader with parse_at(endian, class, offset, data) {
  let end = checked_add(offset, SectionHeader::size_for(class))
  let record = slice_checked(data, offset, end)
  let shdr = match (class, endian) {
    (ELF32, Little) =>
      match record {
        [
          u32le(sh_name),
          u32le(sh_type),
          u32le(sh_flags32),
          u32le(sh_addr32),
          u32le(sh_offset32),
          u32le(sh_size32),
          u32le(sh_link),
          u32le(sh_info),
          u32le(sh_addralign32),
          u32le(sh_entsize32),
        ] =>
          {
            sh_name,
            sh_type,
            sh_flags: sh_flags32.to_uint64(),
            sh_addr: sh_addr32.to_uint64(),
            sh_offset: sh_offset32.to_uint64(),
            sh_size: sh_size32.to_uint64(),
            sh_link,
            sh_info,
            sh_addralign: sh_addralign32.to_uint64(),
            sh_entsize: sh_entsize32.to_uint64(),
          }
        _ => raise SliceReadError(offset, end)
      }
    (ELF32, Big) =>
      match record {
        [
          u32be(sh_name),
          u32be(sh_type),
          u32be(sh_flags32),
          u32be(sh_addr32),
          u32be(sh_offset32),
          u32be(sh_size32),
          u32be(sh_link),
          u32be(sh_info),
          u32be(sh_addralign32),
          u32be(sh_entsize32),
        ] =>
          {
            sh_name,
            sh_type,
            sh_flags: sh_flags32.to_uint64(),
            sh_addr: sh_addr32.to_uint64(),
            sh_offset: sh_offset32.to_uint64(),
            sh_size: sh_size32.to_uint64(),
            sh_link,
            sh_info,
            sh_addralign: sh_addralign32.to_uint64(),
            sh_entsize: sh_entsize32.to_uint64(),
          }
        _ => raise SliceReadError(offset, end)
      }
    (ELF64, Little) =>
      match record {
        [
          u32le(sh_name),
          u32le(sh_type),
          u64le(sh_flags),
          u64le(sh_addr),
          u64le(sh_offset),
          u64le(sh_size),
          u32le(sh_link),
          u32le(sh_info),
          u64le(sh_addralign),
          u64le(sh_entsize),
        ] =>
          {
            sh_name,
            sh_type,
            sh_flags,
            sh_addr,
            sh_offset,
            sh_size,
            sh_link,
            sh_info,
            sh_addralign,
            sh_entsize,
          }
        _ => raise SliceReadError(offset, end)
      }
    (ELF64, Big) =>
      match record {
        [
          u32be(sh_name),
          u32be(sh_type),
          u64be(sh_flags),
          u64be(sh_addr),
          u64be(sh_offset),
          u64be(sh_size),
          u32be(sh_link),
          u32be(sh_info),
          u64be(sh_addralign),
          u64be(sh_entsize),
        ] =>
          {
            sh_name,
            sh_type,
            sh_flags,
            sh_addr,
            sh_offset,
            sh_size,
            sh_link,
            sh_info,
            sh_addralign,
            sh_entsize,
          }
        _ => raise SliceReadError(offset, end)
      }
  }
  (shdr, end)
}

///|
/// Size in bytes of one section header for the given ELF class.
pub fn SectionHeader::size_for(class : Class) -> Int {
  match class {
    ELF32 => 40
    ELF64 => 64
  }
}

///|
// Convert this section's `(sh_offset, sh_size)` pair to a checked byte range.
fn SectionHeader::get_data_range(
  self : SectionHeader,
) -> (Int, Int) raise ParseError {
  let start = u64_to_int_checked(self.sh_offset)
  let size = u64_to_int_checked(self.sh_size)
  let end = checked_add(start, size)
  (start, end)
}
