///|
/// Error raised while validating or lazily parsing ELF data.
///
/// Most variants point at malformed input rather than programmer bugs. The
/// parser checks arithmetic, table entry sizes, and byte ranges before slicing
/// into the original file data.
pub(all) suberror ParseError {
  /// The first four bytes did not match the ELF magic bytes `0x7fELF`.
  BadMagic(Bytes)
  /// `e_ident[EI_CLASS]` was not one of the supported `ELFCLASS*` values.
  UnsupportedElfClass(Byte)
  /// `e_ident[EI_DATA]` was not one of the supported `ELFDATA*` values.
  UnsupportedElfEndianness(Byte)
  /// A version field contained `(found, expected)` where only `expected` is supported.
  UnsupportedVersion(UInt64, UInt64)
  /// A requested table entry or string-table offset was out of bounds.
  BadOffset(UInt64)
  /// No terminating NUL byte was found while reading a string table entry.
  StringTableMissingNul(UInt64)
  /// A table declared `(found, expected)` entry size bytes.
  BadEntsize(UInt64, UInt64)
  /// A section helper was called on `(found, expected)` section types.
  UnexpectedSectionType(UInt, UInt)
  /// A segment helper was called on `(found, expected)` segment types.
  UnexpectedSegmentType(UInt, UInt)
  /// A note or other structured payload declared an unsupported alignment.
  UnexpectedAlignment(Int)
  /// A byte slice `[start, end)` could not be read from the source buffer.
  SliceReadError(Int, Int)
  /// Checked offset or size arithmetic overflowed MoonBit's `Int` range.
  IntegerOverflow
  /// A string table or note name could not be decoded as UTF-8.
  Utf8Error
} derive(Debug, Eq)
