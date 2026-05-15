///|
/// Byte order used by integer fields in the parsed ELF file.
///
/// The value is decoded from `e_ident[EI_DATA]` and then threaded through all
/// lazy parsing tables so every field is read with the file's byte order.
pub(all) enum Endian {
  /// Least-significant byte first, as indicated by `ELFDATA2LSB`.
  Little
  /// Most-significant byte first, as indicated by `ELFDATA2MSB`.
  Big
} derive(Debug, Eq)

///|
/// Decode the ELF identity byte `EI_DATA` into an `Endian` value.
///
/// Raises `UnsupportedElfEndianness` for unknown or reserved values.
pub fn Endian::from_ei_data(ei_data : Byte) -> Endian raise ParseError {
  match ei_data {
    ELFDATA2LSB => Little
    ELFDATA2MSB => Big
    other => raise UnsupportedElfEndianness(other)
  }
}

///|
/// Returns `true` when this byte order is little-endian.
pub fn Endian::is_little(self : Endian) -> Bool {
  match self {
    Little => true
    Big => false
  }
}

///|
/// Returns `true` when this byte order is big-endian.
pub fn Endian::is_big(self : Endian) -> Bool {
  !self.is_little()
}
