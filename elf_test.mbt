// Blackbox tests run against the package's public API. Use `@elf` to import.
// Prefer high-level behaviors over implementation details.
// Run `moon test` to execute and `moon test --update` to refresh snapshots.

///|
fn append_zeroes(out : Array[Byte], count : Int) -> Unit {
  let mut i = 0
  while i < count {
    out.push(0)
    i += 1
  }
}

///|
fn append_bytes(out : Array[Byte], bytes : Bytes) -> Unit {
  for byte in bytes {
    out.push(byte)
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
fn append_u64le(out : Array[Byte], value : UInt64) -> Unit {
  out.push((value & 0xffUL).to_byte())
  out.push(((value >> 8) & 0xffUL).to_byte())
  out.push(((value >> 16) & 0xffUL).to_byte())
  out.push(((value >> 24) & 0xffUL).to_byte())
  out.push(((value >> 32) & 0xffUL).to_byte())
  out.push(((value >> 40) & 0xffUL).to_byte())
  out.push(((value >> 48) & 0xffUL).to_byte())
  out.push(((value >> 56) & 0xffUL).to_byte())
}

///|
fn append_ident(out : Array[Byte]) -> Unit {
  out.push(@elf.ELFMAG0)
  out.push(@elf.ELFMAG1)
  out.push(@elf.ELFMAG2)
  out.push(@elf.ELFMAG3)
  out.push(@elf.ELFCLASS64)
  out.push(@elf.ELFDATA2LSB)
  out.push(@elf.EV_CURRENT)
  out.push(@elf.ELFOSABI_SYSV)
  out.push(0)
  append_zeroes(out, 7)
}

///|
fn append_elf64_header(
  out : Array[Byte],
  shoff : UInt64,
  shnum : UInt16,
  shstrndx : UInt16,
) -> Unit {
  append_ident(out)
  append_u16le(out, @elf.ET_EXEC)
  append_u16le(out, @elf.EM_X86_64)
  append_u32le(out, 1U)
  append_u64le(out, 0x401000UL)
  append_u64le(out, 0UL)
  append_u64le(out, shoff)
  append_u32le(out, 0U)
  append_u16le(out, 64)
  append_u16le(out, 56)
  append_u16le(out, 0)
  append_u16le(out, 64)
  append_u16le(out, shnum)
  append_u16le(out, shstrndx)
}

///|
fn append_shdr64le(
  out : Array[Byte],
  name : UInt,
  sh_type : UInt,
  flags : UInt64,
  addr : UInt64,
  offset : UInt64,
  size : UInt64,
  link : UInt,
  info : UInt,
  align : UInt64,
  entsize : UInt64,
) -> Unit {
  append_u32le(out, name)
  append_u32le(out, sh_type)
  append_u64le(out, flags)
  append_u64le(out, addr)
  append_u64le(out, offset)
  append_u64le(out, size)
  append_u32le(out, link)
  append_u32le(out, info)
  append_u64le(out, align)
  append_u64le(out, entsize)
}

///|
fn minimal_elf64_le() -> Bytes {
  let out : Array[Byte] = []
  append_elf64_header(out, 0UL, 0, 0)
  Bytes::from_array(out)
}

///|
fn elf64_le_with_bad_header_version() -> Bytes {
  let out : Array[Byte] = []
  append_ident(out)
  append_u16le(out, @elf.ET_EXEC)
  append_u16le(out, @elf.EM_X86_64)
  append_u32le(out, 2U)
  append_u64le(out, 0x401000UL)
  append_u64le(out, 0UL)
  append_u64le(out, 0UL)
  append_u32le(out, 0U)
  append_u16le(out, 64)
  append_u16le(out, 56)
  append_u16le(out, 0)
  append_u16le(out, 64)
  append_u16le(out, 0)
  append_u16le(out, 0)
  Bytes::from_array(out)
}

///|
fn sectioned_elf64_le() -> Bytes {
  let out : Array[Byte] = []
  let shoff = 64UL
  let text_offset = 256UL
  let shstrtab_offset = 260UL
  append_elf64_header(out, shoff, 3, 2)
  append_shdr64le(out, 0U, @elf.SHT_NULL, 0UL, 0UL, 0UL, 0UL, 0U, 0U, 0UL, 0UL)
  append_shdr64le(
    out,
    1U,
    @elf.SHT_PROGBITS,
    (@elf.SHF_ALLOC | @elf.SHF_EXECINSTR).to_uint64(),
    0UL,
    text_offset,
    4UL,
    0U,
    0U,
    1UL,
    0UL,
  )
  append_shdr64le(
    out,
    7U,
    @elf.SHT_STRTAB,
    0UL,
    0UL,
    shstrtab_offset,
    17UL,
    0U,
    0U,
    1UL,
    0UL,
  )
  append_bytes(out, b"\xde\xad\xbe\xef")
  append_bytes(out, b"\x00.text\x00.shstrtab\x00")
  Bytes::from_array(out)
}

///|
test "minimal_parse elf64 little endian header" {
  let data = minimal_elf64_le()
  let elf = @elf.ElfBytes::minimal_parse(data[:])
  assert_true(elf.ehdr.class is ELF64)
  assert_true(elf.ehdr.endianness is Little)
  @debug.assert_eq(elf.ehdr.e_type, @elf.ET_EXEC)
  @debug.assert_eq(elf.ehdr.e_machine, @elf.EM_X86_64)
  @debug.assert_eq(elf.ehdr.e_entry, 0x401000UL)
  assert_true(elf.segments() is None)
  assert_true(elf.section_headers() is None)
}

///|
test "minimal_parse rejects bad magic" {
  let data = Bytes::make(64, 0)
  try @elf.ElfBytes::minimal_parse(data[:]) catch {
    BadMagic(magic) => @debug.assert_eq(magic, b"\x00\x00\x00\x00")
    _ => fail("expected BadMagic")
  } noraise {
    _ => fail("expected BadMagic")
  }
}

///|
test "minimal_parse rejects unsupported header version" {
  let data = elf64_le_with_bad_header_version()
  try @elf.ElfBytes::minimal_parse(data[:]) catch {
    UnsupportedVersion(2UL, 1UL) => ()
    _ => fail("expected UnsupportedVersion")
  } noraise {
    _ => fail("expected UnsupportedVersion")
  }
}

///|
test "section headers names and section data" {
  let data = sectioned_elf64_le()
  let elf = @elf.ElfBytes::minimal_parse(data[:])
  let shdrs = match elf.section_headers() {
    Some(shdrs) => shdrs
    None => fail("expected section headers")
  }
  @debug.assert_eq(shdrs.len(), 3)
  let (shdrs_with_strs, shstrtab_opt) = elf.section_headers_with_strtab()
  match shdrs_with_strs {
    Some(table) => {
      @debug.assert_eq(table.len(), shdrs.len())
      assert_true(table.get(1) == shdrs.get(1))
      assert_true(table.get(2) == shdrs.get(2))
    }
    None => fail("expected section headers with string table")
  }
  let shstrtab = match shstrtab_opt {
    Some(strtab) => strtab
    None => fail("expected section string table")
  }
  @debug.assert_eq(shstrtab.get(1), ".text")
  @debug.assert_eq(shstrtab.get(7), ".shstrtab")
  let text = match elf.section_header_by_name(".text") {
    Some(shdr) => shdr
    None => fail("expected .text")
  }
  @debug.assert_eq(text.sh_type, @elf.SHT_PROGBITS)
  let (text_data, compression) = elf.section_data(text)
  assert_true(compression is None)
  @debug.assert_eq(text_data.to_owned(), b"\xde\xad\xbe\xef")
  let names = match elf.section_header_by_name(".shstrtab") {
    Some(shdr) => elf.section_data_as_strtab(shdr)
    None => fail("expected .shstrtab")
  }
  @debug.assert_eq(names.get(7), ".shstrtab")
  try elf.section_data_as_strtab(text) catch {
    UnexpectedSectionType(actual, expected) => {
      @debug.assert_eq(actual, @elf.SHT_PROGBITS)
      @debug.assert_eq(expected, @elf.SHT_STRTAB)
    }
    _ => fail("expected UnexpectedSectionType")
  } noraise {
    _ => fail("expected UnexpectedSectionType")
  }
}

///|
test "string table get and missing nul" {
  let table = @elf.StringTable::new(b"\x00alpha\x00beta\x00"[:])
  @debug.assert_eq(table.get(1), "alpha")
  @debug.assert_eq(table.get_raw(7).to_owned(), b"beta")
  let unterminated = @elf.StringTable::new(b"name"[:])
  try unterminated.get(0) catch {
    StringTableMissingNul(0UL) => ()
    _ => fail("expected StringTableMissingNul")
  } noraise {
    _ => fail("expected StringTableMissingNul")
  }
}

///|
test "string table bad offset preserves requested offset" {
  let table = @elf.StringTable::new(b"\x00alpha\x00"[:])
  try table.get_raw(9) catch {
    BadOffset(9UL) => ()
    _ => fail("expected BadOffset(9)")
  } noraise {
    _ => fail("expected BadOffset(9)")
  }
  let empty = @elf.StringTable::default()
  try empty.get_raw(7) catch {
    BadOffset(7UL) => ()
    _ => fail("expected BadOffset(7)")
  } noraise {
    _ => fail("expected BadOffset(7)")
  }
}

///|
test "to_str mappings" {
  @debug.assert_eq(
    @elf.e_osabi_to_str(@elf.ELFOSABI_MODESTO),
    Some("ELFOSABI_MODESTO"),
  )
  @debug.assert_eq(
    @elf.e_osabi_to_str(@elf.ELFOSABI_OPENVMS),
    Some("ELFOSABI_OPENVMS"),
  )
  @debug.assert_eq(@elf.e_machine_to_str(@elf.EM_PPC64), Some("EM_PPC64"))
  @debug.assert_eq(
    @elf.e_machine_to_human_str(@elf.EM_PPC64),
    Some("64-bit PowerPC"),
  )
  @debug.assert_eq(
    @elf.sh_type_to_str(@elf.SHT_INIT_ARRAY),
    Some("SHT_INIT_ARRAY"),
  )
  @debug.assert_eq(
    @elf.p_type_to_str(@elf.PT_GNU_PROPERTY),
    Some("PT_GNU_PROPERTY"),
  )
  @debug.assert_eq(@elf.d_tag_to_str(@elf.DT_HASH), Some("DT_HASH"))
  @debug.assert_eq(
    @elf.ch_type_to_str(@elf.ELFCOMPRESS_ZLIB),
    Some("ELFCOMPRESS_ZLIB"),
  )
  @debug.assert_eq(
    @elf.note_abi_tag_os_to_str(@elf.ELF_NOTE_GNU_ABI_TAG_OS_LINUX),
    Some("Linux"),
  )
  @debug.assert_eq(
    @elf.p_flags_to_string(@elf.PF_R | @elf.PF_W | @elf.PF_X),
    "RWE",
  )
}

///|
test "elf hash helpers match known values" {
  @debug.assert_eq(@elf.sysv_hash(b"abc"[:]), 0x6783U)
  @debug.assert_eq(@elf.sysv_hash(b"printf"[:]), 0x077905a6U)
  @debug.assert_eq(@elf.gnu_hash(b"abc"[:]), 0x0b885c8bU)
  @debug.assert_eq(@elf.gnu_hash(b"printf"[:]), 0x156b2bb8U)
}
