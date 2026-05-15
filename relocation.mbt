///|
/// Lazy table for relocation entries without explicit addends (`SHT_REL`).
pub struct RelIterator {
  table : ParsingTable[Rel]
}

///|
/// Lazy table for relocation entries with explicit addends (`SHT_RELA`).
pub struct RelaIterator {
  table : ParsingTable[Rela]
}

///|
fn RelIterator::RelIterator(
  endian : Endian,
  class : Class,
  data : BytesView,
) -> RelIterator {
  {
    table: ParsingTable(
      endian,
      class,
      data,
      Rel::size_for(class),
      Rel::parse_at,
    ),
  }
}

///|
fn RelaIterator::RelaIterator(
  endian : Endian,
  class : Class,
  data : BytesView,
) -> RelaIterator {
  {
    table: ParsingTable(
      endian,
      class,
      data,
      Rela::size_for(class),
      Rela::parse_at,
    ),
  }
}

///|
/// Number of `Rel` entries.
pub fn RelIterator::len(self : RelIterator) -> Int {
  self.table.len()
}

///|
/// Returns `true` when there are no `Rel` entries.
pub fn RelIterator::is_empty(self : RelIterator) -> Bool {
  self.table.is_empty()
}

///|
/// Parse the `Rel` entry at `index`.
pub fn RelIterator::get(
  self : RelIterator,
  index : Int,
) -> Rel raise ParseError {
  self.table.get(index)
}

///|
/// Iterate over `Rel` entries lazily.
pub fn RelIterator::iter(self : RelIterator) -> Iter[Rel] {
  self.table.iter()
}

///|
/// Number of `Rela` entries.
pub fn RelaIterator::len(self : RelaIterator) -> Int {
  self.table.len()
}

///|
/// Returns `true` when there are no `Rela` entries.
pub fn RelaIterator::is_empty(self : RelaIterator) -> Bool {
  self.table.is_empty()
}

///|
/// Parse the `Rela` entry at `index`.
pub fn RelaIterator::get(
  self : RelaIterator,
  index : Int,
) -> Rela raise ParseError {
  self.table.get(index)
}

///|
/// Iterate over `Rela` entries lazily.
pub fn RelaIterator::iter(self : RelaIterator) -> Iter[Rela] {
  self.table.iter()
}

///|
/// ELF relocation entry without an explicit addend.
///
/// The packed ELF `r_info` word is split into `r_sym` and `r_type` while
/// parsing, using the ELF32 or ELF64 packing rule.
pub(all) struct Rel {
  /// Location to relocate. Interpretation depends on file type and architecture.
  r_offset : UInt64
  /// Symbol table index referenced by this relocation.
  r_sym : UInt
  /// Processor-specific relocation type.
  r_type : UInt
} derive(Debug, Eq)

///|
impl ParseAt for Rel with parse_at(endian, class, offset, data) {
  let end = checked_add(offset, Rel::size_for(class))
  let record = slice_checked(data, offset, end)
  let rel = match (class, endian) {
    (ELF32, Little) =>
      match record {
        [u32le(r_offset32), u32le(r_info)] =>
          {
            r_offset: r_offset32.to_uint64(),
            r_sym: r_info >> 8,
            r_type: r_info & 0xffU,
          }
        _ => raise SliceReadError(offset, end)
      }
    (ELF32, Big) =>
      match record {
        [u32be(r_offset32), u32be(r_info)] =>
          {
            r_offset: r_offset32.to_uint64(),
            r_sym: r_info >> 8,
            r_type: r_info & 0xffU,
          }
        _ => raise SliceReadError(offset, end)
      }
    (ELF64, Little) =>
      match record {
        [u64le(r_offset), u64le(r_info)] =>
          {
            r_offset,
            r_sym: (r_info >> 32).to_uint(),
            r_type: (r_info & 0xffffffffUL).to_uint(),
          }
        _ => raise SliceReadError(offset, end)
      }
    (ELF64, Big) =>
      match record {
        [u64be(r_offset), u64be(r_info)] =>
          {
            r_offset,
            r_sym: (r_info >> 32).to_uint(),
            r_type: (r_info & 0xffffffffUL).to_uint(),
          }
        _ => raise SliceReadError(offset, end)
      }
  }
  (rel, end)
}

///|
/// Size in bytes of one no-addend relocation for the given ELF class.
pub fn Rel::size_for(class : Class) -> Int {
  match class {
    ELF32 => 8
    ELF64 => 16
  }
}

///|
/// ELF relocation entry with an explicit signed addend.
///
/// Like `Rel`, the packed `r_info` word is split into `r_sym` and `r_type`.
pub(all) struct Rela {
  /// Location to relocate. Interpretation depends on file type and architecture.
  r_offset : UInt64
  /// Symbol table index referenced by this relocation.
  r_sym : UInt
  /// Processor-specific relocation type.
  r_type : UInt
  /// Explicit addend supplied by the relocation entry.
  r_addend : Int64
} derive(Debug, Eq)

///|
impl ParseAt for Rela with parse_at(endian, class, offset, data) {
  let end = checked_add(offset, Rela::size_for(class))
  let record = slice_checked(data, offset, end)
  let rela = match (class, endian) {
    (ELF32, Little) =>
      match record {
        [u32le(r_offset32), u32le(r_info), u32le(r_addend32)] =>
          {
            r_offset: r_offset32.to_uint64(),
            r_sym: r_info >> 8,
            r_type: r_info & 0xffU,
            r_addend: r_addend32.reinterpret_as_int().to_int64(),
          }
        _ => raise SliceReadError(offset, end)
      }
    (ELF32, Big) =>
      match record {
        [u32be(r_offset32), u32be(r_info), u32be(r_addend32)] =>
          {
            r_offset: r_offset32.to_uint64(),
            r_sym: r_info >> 8,
            r_type: r_info & 0xffU,
            r_addend: r_addend32.reinterpret_as_int().to_int64(),
          }
        _ => raise SliceReadError(offset, end)
      }
    (ELF64, Little) =>
      match record {
        [u64le(r_offset), u64le(r_info), u64le(r_addend)] =>
          {
            r_offset,
            r_sym: (r_info >> 32).to_uint(),
            r_type: (r_info & 0xffffffffUL).to_uint(),
            r_addend: r_addend.reinterpret_as_int64(),
          }
        _ => raise SliceReadError(offset, end)
      }
    (ELF64, Big) =>
      match record {
        [u64be(r_offset), u64be(r_info), u64be(r_addend)] =>
          {
            r_offset,
            r_sym: (r_info >> 32).to_uint(),
            r_type: (r_info & 0xffffffffUL).to_uint(),
            r_addend: r_addend.reinterpret_as_int64(),
          }
        _ => raise SliceReadError(offset, end)
      }
  }
  (rela, end)
}

///|
/// Size in bytes of one addend relocation for the given ELF class.
pub fn Rela::size_for(class : Class) -> Int {
  match class {
    ELF32 => 12
    ELF64 => 24
  }
}
