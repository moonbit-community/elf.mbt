///|
/// View over an ELF string table section.
///
/// ELF string tables are byte arrays containing NUL-terminated strings. Offsets
/// into the table are stored in other records, for example `st_name` in symbols
/// and `sh_name` in section headers.
pub(all) struct StringTable {
  /// Raw string table bytes.
  data : BytesView
} derive(Debug, Eq)

///|
/// Construct a string table view from raw section bytes.
pub fn StringTable::new(data : BytesView) -> StringTable {
  { data, }
}

///|
/// Construct an empty string table.
///
/// Accessing any offset in the empty table raises `BadOffset`.
pub fn StringTable::default() -> StringTable {
  { data: b""[:] }
}

///|
/// Return the raw bytes for the NUL-terminated string at `offset`.
///
/// The returned view excludes the terminating NUL byte. Raises `BadOffset` if
/// the offset is outside the table and `StringTableMissingNul` if no terminator
/// appears before the table ends.
pub fn StringTable::get_raw(
  self : StringTable,
  offset : Int,
) -> BytesView raise ParseError {
  if offset < 0 {
    raise BadOffset(0UL)
  }
  if self.data.is_empty() || offset >= self.data.length() {
    raise BadOffset(offset.to_uint64())
  }
  let mut idx = offset
  while idx < self.data.length() {
    if self.data[idx] == 0 {
      return self.data[offset:idx]
    }
    idx += 1
  }
  raise StringTableMissingNul(offset.to_uint64())
}

///|
/// Decode the NUL-terminated string at `offset` as UTF-8.
///
/// This is a convenience wrapper around `get_raw`; it raises `Utf8Error` for
/// non-UTF-8 byte sequences.
pub fn StringTable::get(
  self : StringTable,
  offset : Int,
) -> String raise ParseError {
  let raw = self.get_raw(offset)
  @utf8.decode(raw) catch {
    _ => raise Utf8Error
  }
}
