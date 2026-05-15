///|
fn append_zeroes(out : Array[Byte], count : Int) -> Unit {
  let mut i = 0
  while i < count {
    out.push(0)
    i += 1
  }
}

///|
fn append_u16le(out : Array[Byte], value : UInt16) -> Unit {
  let v = value.to_int()
  out.push((v & 0xff).to_byte())
  out.push(((v >> 8) & 0xff).to_byte())
}

///|
fn append_u32le(out : Array[Byte], value : UInt) -> Unit {
  out.push((value & 0xffU).to_byte())
  out.push(((value >> 8) & 0xffU).to_byte())
  out.push(((value >> 16) & 0xffU).to_byte())
  out.push(((value >> 24) & 0xffU).to_byte())
}

///|
fn append_ident(out : Array[Byte], class_byte : Byte) -> Unit {
  out.push(ELFMAG0)
  out.push(ELFMAG1)
  out.push(ELFMAG2)
  out.push(ELFMAG3)
  out.push(class_byte)
  out.push(ELFDATA2LSB)
  out.push(EV_CURRENT)
  out.push(ELFOSABI_SYSV)
  out.push(0)
  append_zeroes(out, 7)
}

///|
fn zeroes(count : Int) -> Bytes {
  let out : Array[Byte] = []
  append_zeroes(out, count)
  Bytes::from_array(out)
}

///|
fn truncated_record(size : Int) -> Bytes {
  zeroes(size - 1)
}

///|
fn truncated_versioned_record(size : Int, version : UInt16) -> Bytes {
  let out : Array[Byte] = []
  append_u16le(out, version)
  append_zeroes(out, size - 3)
  Bytes::from_array(out)
}

///|
fn truncated_header_tail(class : Class) -> Bytes {
  let out : Array[Byte] = []
  append_zeroes(out, 4)
  append_u32le(out, EV_CURRENT.to_uint())
  let tail_size = match class {
    ELF32 => ELF32_EHDR_TAILSIZE
    ELF64 => ELF64_EHDR_TAILSIZE
  }
  append_zeroes(out, tail_size - 9)
  Bytes::from_array(out)
}

///|
fn truncated_elf(class_byte : Byte, tail_size : Int) -> Bytes {
  let out : Array[Byte] = []
  append_ident(out, class_byte)
  append_zeroes(out, tail_size - 1)
  Bytes::from_array(out)
}

///|
fn expect_slice_read_error(parse : () -> Unit raise ParseError) -> Unit raise {
  try parse() catch {
    SliceReadError(_, _) => ()
    _ => fail("expected SliceReadError")
  } noraise {
    _ => fail("expected SliceReadError")
  }
}

///|
fn[T] expect_parse_at_truncated(
  size : Int,
  class : Class,
  parser : (Endian, Class, Int, BytesView) -> (T, Int) raise ParseError,
) -> Unit raise {
  let data = truncated_record(size)
  expect_slice_read_error(fn() raise ParseError {
    ignore(parser(Little, class, 0, data[:]))
  })
}

///|
test "parsing table empty get preserves requested index" {
  let table = ParsingTable(Little, ELF32, b""[:], 4, parse_uint_table_at)
  try table.get(7) catch {
    BadOffset(7UL) => ()
    _ => fail("expected BadOffset(7)")
  } noraise {
    _ => fail("expected BadOffset(7)")
  }
}

///|
test "minimal parse and header parser reject truncated input" {
  let short_ident = zeroes(EI_NIDENT - 1)
  expect_slice_read_error(fn() raise ParseError {
    ignore(ElfBytes::minimal_parse(short_ident[:]))
  })
  let short_elf32 = truncated_elf(ELFCLASS32, ELF32_EHDR_TAILSIZE)
  expect_slice_read_error(fn() raise ParseError {
    ignore(ElfBytes::minimal_parse(short_elf32[:]))
  })
  let short_elf64 = truncated_elf(ELFCLASS64, ELF64_EHDR_TAILSIZE)
  expect_slice_read_error(fn() raise ParseError {
    ignore(ElfBytes::minimal_parse(short_elf64[:]))
  })
  let ident32 : (Endian, Class, Byte, Byte) = (Little, ELF32, ELFOSABI_SYSV, 0)
  let tail32 = truncated_header_tail(ELF32)
  expect_slice_read_error(fn() raise ParseError {
    ignore(FileHeader::parse_tail(ident32, tail32[:]))
  })
  let ident64 : (Endian, Class, Byte, Byte) = (Little, ELF64, ELFOSABI_SYSV, 0)
  let tail64 = truncated_header_tail(ELF64)
  expect_slice_read_error(fn() raise ParseError {
    ignore(FileHeader::parse_tail(ident64, tail64[:]))
  })
}

///|
test "fixed record parsers reject truncated input" {
  expect_parse_at_truncated(4, ELF32, parse_uint_table_at)
  expect_parse_at_truncated(8, ELF64, parse_uint64_table_at)
  expect_parse_at_truncated(
    SectionHeader::size_for(ELF32),
    ELF32,
    SectionHeader::parse_at,
  )
  expect_parse_at_truncated(
    SectionHeader::size_for(ELF64),
    ELF64,
    SectionHeader::parse_at,
  )
  expect_parse_at_truncated(
    ProgramHeader::size_for(ELF32),
    ELF32,
    ProgramHeader::parse_at,
  )
  expect_parse_at_truncated(
    ProgramHeader::size_for(ELF64),
    ELF64,
    ProgramHeader::parse_at,
  )
  expect_parse_at_truncated(Symbol::size_for(ELF32), ELF32, Symbol::parse_at)
  expect_parse_at_truncated(Symbol::size_for(ELF64), ELF64, Symbol::parse_at)
  expect_parse_at_truncated(Rel::size_for(ELF32), ELF32, Rel::parse_at)
  expect_parse_at_truncated(Rel::size_for(ELF64), ELF64, Rel::parse_at)
  expect_parse_at_truncated(Rela::size_for(ELF32), ELF32, Rela::parse_at)
  expect_parse_at_truncated(Rela::size_for(ELF64), ELF64, Rela::parse_at)
  expect_parse_at_truncated(Dyn::size_for(ELF32), ELF32, Dyn::parse_at)
  expect_parse_at_truncated(Dyn::size_for(ELF64), ELF64, Dyn::parse_at)
  expect_parse_at_truncated(
    CompressionHeader::size_for(ELF32),
    ELF32,
    CompressionHeader::parse_at,
  )
  expect_parse_at_truncated(
    CompressionHeader::size_for(ELF64),
    ELF64,
    CompressionHeader::parse_at,
  )
  expect_parse_at_truncated(12, ELF32, NoteHeader::parse_at)
  expect_parse_at_truncated(24, ELF64, NoteHeader::parse_at)
  expect_parse_at_truncated(16, ELF32, NoteGnuAbiTag::parse_at)
  expect_parse_at_truncated(8, ELF32, SysVHashHeader::parse_at)
  expect_parse_at_truncated(16, ELF32, GnuHashHeader::parse_at)
  expect_parse_at_truncated(
    VersionIndex::size_for(ELF32),
    ELF32,
    VersionIndex::parse_at,
  )
  expect_parse_at_truncated(
    VerDefAux::size_for(ELF32),
    ELF32,
    VerDefAux::parse_at,
  )
  expect_parse_at_truncated(
    VerNeedAux::size_for(ELF32),
    ELF32,
    VerNeedAux::parse_at,
  )
}

///|
test "version and note parsers reject truncated input" {
  let verdef = truncated_versioned_record(
    VerDef::size_for(ELF32),
    VER_DEF_CURRENT,
  )
  expect_slice_read_error(fn() raise ParseError {
    ignore(VerDef::parse_at(Little, ELF32, 0, verdef[:]))
  })
  let verneed = truncated_versioned_record(
    VerNeed::size_for(ELF32),
    VER_NEED_CURRENT,
  )
  expect_slice_read_error(fn() raise ParseError {
    ignore(VerNeed::parse_at(Little, ELF32, 0, verneed[:]))
  })
  let note = truncated_record(12)
  expect_slice_read_error(fn() raise ParseError {
    ignore(Note::parse_at(Little, ELF32, 4, 0, note[:]))
  })
}
