///|
/// Lazy table of `.dynamic` entries.
///
/// Dynamic tables can come from an `SHT_DYNAMIC` section or from a `PT_DYNAMIC`
/// program segment. Entries are parsed on demand as `Dyn` records.
pub struct DynamicTable {
  table : ParsingTable[Dyn]
}

///|
fn DynamicTable::DynamicTable(
  endian : Endian,
  class : Class,
  data : BytesView,
) -> DynamicTable {
  {
    table: ParsingTable(
      endian,
      class,
      data,
      Dyn::size_for(class),
      Dyn::parse_at,
    ),
  }
}

///|
/// Number of dynamic entries in the table.
pub fn DynamicTable::len(self : DynamicTable) -> Int {
  self.table.len()
}

///|
/// Returns `true` when the dynamic table has no entries.
pub fn DynamicTable::is_empty(self : DynamicTable) -> Bool {
  self.table.is_empty()
}

///|
/// Parse the dynamic entry at `index`.
pub fn DynamicTable::get(
  self : DynamicTable,
  index : Int,
) -> Dyn raise ParseError {
  self.table.get(index)
}

///|
/// Iterate over dynamic entries, parsing each entry as needed.
pub fn DynamicTable::iter(self : DynamicTable) -> Iter[Dyn] {
  self.table.iter()
}

///|
/// One ELF dynamic-section entry.
///
/// `d_tag` identifies the meaning of `d_un`. The ELF ABI models `d_un` as a
/// union, so both `d_val` and `d_ptr` return the same stored word.
pub(all) struct Dyn {
  /// Dynamic tag such as `DT_NEEDED`, `DT_STRTAB`, or `DT_RELA`.
  d_tag : Int64
  /// Raw union payload for `d_val` or `d_ptr`.
  d_un : UInt64
} derive(Debug, Eq)

///|
/// Interpret the union payload as an integer value.
pub fn Dyn::d_val(self : Dyn) -> UInt64 {
  self.d_un
}

///|
/// Interpret the union payload as a virtual address or pointer value.
pub fn Dyn::d_ptr(self : Dyn) -> UInt64 {
  self.d_un
}

///|
impl ParseAt for Dyn with parse_at(endian, class, offset, data) {
  let end = checked_add(offset, Dyn::size_for(class))
  let record = slice_checked(data, offset, end)
  let entry = match (class, endian) {
    (ELF32, Little) =>
      match record {
        [u32le(d_tag32), u32le(d_un32)] =>
          {
            d_tag: d_tag32.reinterpret_as_int().to_int64(),
            d_un: d_un32.to_uint64(),
          }
        _ => raise SliceReadError(offset, end)
      }
    (ELF32, Big) =>
      match record {
        [u32be(d_tag32), u32be(d_un32)] =>
          {
            d_tag: d_tag32.reinterpret_as_int().to_int64(),
            d_un: d_un32.to_uint64(),
          }
        _ => raise SliceReadError(offset, end)
      }
    (ELF64, Little) =>
      match record {
        [u64le(d_tag), u64le(d_un)] =>
          { d_tag: d_tag.reinterpret_as_int64(), d_un }
        _ => raise SliceReadError(offset, end)
      }
    (ELF64, Big) =>
      match record {
        [u64be(d_tag), u64be(d_un)] =>
          { d_tag: d_tag.reinterpret_as_int64(), d_un }
        _ => raise SliceReadError(offset, end)
      }
  }
  (entry, end)
}

///|
/// Size in bytes of one dynamic entry for the given ELF class.
pub fn Dyn::size_for(class : Class) -> Int {
  match class {
    ELF32 => 8
    ELF64 => 16
  }
}
