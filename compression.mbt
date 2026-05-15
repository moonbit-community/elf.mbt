///|
/// ELF compression header for sections marked with `SHF_COMPRESSED`.
///
/// The parser returns this header together with the remaining compressed
/// payload bytes. It does not perform decompression; callers choose the
/// decompressor matching `ch_type` such as `ELFCOMPRESS_ZLIB` or
/// `ELFCOMPRESS_ZSTD`.
pub(all) struct CompressionHeader {
  /// Compression algorithm identifier (`ELFCOMPRESS_*`).
  ch_type : UInt
  /// Uncompressed section size in bytes.
  ch_size : UInt64
  /// Required alignment of the uncompressed data.
  ch_addralign : UInt64
} derive(Debug, Eq)

///|
impl ParseAt for CompressionHeader with parse_at(endian, class, offset, data) {
  let end = checked_add(offset, CompressionHeader::size_for(class))
  let record = slice_checked(data, offset, end)
  let header = match (class, endian) {
    (ELF32, Little) =>
      match record {
        [u32le(ch_type), u32le(ch_size32), u32le(ch_addralign32)] =>
          {
            ch_type,
            ch_size: ch_size32.to_uint64(),
            ch_addralign: ch_addralign32.to_uint64(),
          }
        _ => raise SliceReadError(offset, end)
      }
    (ELF32, Big) =>
      match record {
        [u32be(ch_type), u32be(ch_size32), u32be(ch_addralign32)] =>
          {
            ch_type,
            ch_size: ch_size32.to_uint64(),
            ch_addralign: ch_addralign32.to_uint64(),
          }
        _ => raise SliceReadError(offset, end)
      }
    (ELF64, Little) =>
      match record {
        [u32le(ch_type), u32le(_reserved), u64le(ch_size), u64le(ch_addralign)] =>
          { ch_type, ch_size, ch_addralign }
        _ => raise SliceReadError(offset, end)
      }
    (ELF64, Big) =>
      match record {
        [u32be(ch_type), u32be(_reserved), u64be(ch_size), u64be(ch_addralign)] =>
          { ch_type, ch_size, ch_addralign }
        _ => raise SliceReadError(offset, end)
      }
  }
  (header, end)
}

///|
/// Size in bytes of an ELF compression header for the given class.
pub fn CompressionHeader::size_for(class : Class) -> Int {
  match class {
    ELF32 => 12
    ELF64 => 24
  }
}
