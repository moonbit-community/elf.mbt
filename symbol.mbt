///|
/// Lazy table of ELF symbol entries.
///
/// Symbol tables are usually paired with a linked `StringTable` that resolves
/// each symbol's `st_name` offset into a human-readable name.
pub struct SymbolTable {
  table : ParsingTable[Symbol]
}

///|
fn SymbolTable::SymbolTable(
  endian : Endian,
  class : Class,
  data : BytesView,
) -> SymbolTable {
  {
    table: ParsingTable(
      endian,
      class,
      data,
      Symbol::size_for(class),
      Symbol::parse_at,
    ),
  }
}

///|
/// Number of symbols in the table.
pub fn SymbolTable::len(self : SymbolTable) -> Int {
  self.table.len()
}

///|
/// Returns `true` when the symbol table has no entries.
pub fn SymbolTable::is_empty(self : SymbolTable) -> Bool {
  self.table.is_empty()
}

///|
/// Parse the symbol at `index`.
pub fn SymbolTable::get(
  self : SymbolTable,
  index : Int,
) -> Symbol raise ParseError {
  self.table.get(index)
}

///|
/// Iterate over symbols, parsing each entry lazily.
pub fn SymbolTable::iter(self : SymbolTable) -> Iter[Symbol] {
  self.table.iter()
}

///|
/// ELF symbol table entry normalized across ELF32 and ELF64 layouts.
///
/// The `st_name` field is an offset into the symbol table's linked string
/// table. `st_info` packs binding and type, and `st_other` packs visibility.
pub(all) struct Symbol {
  /// Offset of the symbol name in the linked string table.
  st_name : UInt
  /// Section index that defines this symbol, or a special `SHN_*` value.
  st_shndx : UInt16
  /// Packed symbol binding and symbol type.
  st_info : Byte
  /// Packed symbol visibility and reserved bits.
  st_other : Byte
  /// Symbol value: section offset, virtual address, absolute value, or alignment.
  st_value : UInt64
  /// Symbol size in bytes, or zero when unknown/not applicable.
  st_size : UInt64
} derive(Debug, Eq)

///|
/// Returns `true` when the symbol is undefined in this object.
///
/// Undefined symbols are expected to be resolved from another object during
/// static or dynamic linking.
pub fn Symbol::is_undefined(self : Symbol) -> Bool {
  self.st_shndx == SHN_UNDEF
}

///|
/// Extract the low-nibble symbol type from `st_info`.
pub fn Symbol::st_symtype(self : Symbol) -> Byte {
  self.st_info & 0x0f
}

///|
/// Extract the high-nibble symbol binding from `st_info`.
pub fn Symbol::st_bind(self : Symbol) -> Byte {
  self.st_info >> 4
}

///|
/// Extract the two-bit visibility from `st_other`.
pub fn Symbol::st_vis(self : Symbol) -> Byte {
  self.st_other & 0x03
}

///|
impl ParseAt for Symbol with parse_at(endian, class, offset, data) {
  let end = checked_add(offset, Symbol::size_for(class))
  let record = slice_checked(data, offset, end)
  let symbol = match (class, endian) {
    (ELF32, Little) =>
      match record {
        [
          u32le(st_name),
          u32le(st_value32),
          u32le(st_size32),
          st_info,
          st_other,
          u16le(st_shndx),
        ] =>
          {
            st_name,
            st_shndx: st_shndx.to_uint16(),
            st_info,
            st_other,
            st_value: st_value32.to_uint64(),
            st_size: st_size32.to_uint64(),
          }
        _ => raise SliceReadError(offset, end)
      }
    (ELF32, Big) =>
      match record {
        [
          u32be(st_name),
          u32be(st_value32),
          u32be(st_size32),
          st_info,
          st_other,
          u16be(st_shndx),
        ] =>
          {
            st_name,
            st_shndx: st_shndx.to_uint16(),
            st_info,
            st_other,
            st_value: st_value32.to_uint64(),
            st_size: st_size32.to_uint64(),
          }
        _ => raise SliceReadError(offset, end)
      }
    (ELF64, Little) =>
      match record {
        [
          u32le(st_name),
          st_info,
          st_other,
          u16le(st_shndx),
          u64le(st_value),
          u64le(st_size),
        ] =>
          {
            st_name,
            st_shndx: st_shndx.to_uint16(),
            st_info,
            st_other,
            st_value,
            st_size,
          }
        _ => raise SliceReadError(offset, end)
      }
    (ELF64, Big) =>
      match record {
        [
          u32be(st_name),
          st_info,
          st_other,
          u16be(st_shndx),
          u64be(st_value),
          u64be(st_size),
        ] =>
          {
            st_name,
            st_shndx: st_shndx.to_uint16(),
            st_info,
            st_other,
            st_value,
            st_size,
          }
        _ => raise SliceReadError(offset, end)
      }
  }
  (symbol, end)
}

///|
/// Size in bytes of one symbol entry for the given ELF class.
pub fn Symbol::size_for(class : Class) -> Int {
  match class {
    ELF32 => 16
    ELF64 => 24
  }
}
