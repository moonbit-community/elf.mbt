///|
fn parse_testdata(name : String) -> @elf.ElfBytes raise {
  let data = @fs.read_file_to_bytes("testdata/" + name)
  @elf.ElfBytes::minimal_parse(data[:])
}

///|
fn[T] unwrap_some(value : T?, message : String) -> T raise {
  match value {
    Some(value) => value
    None => fail(message)
  }
}

///|
fn uint_to_int(value : UInt) -> Int {
  value.reinterpret_as_int()
}

///|
fn assert_unexpected_section_type(
  result : () -> Unit raise @elf.ParseError,
  actual : UInt,
  expected : UInt,
) -> Unit raise {
  try result() catch {
    UnexpectedSectionType(got, want) => {
      assert_eq(got, actual)
      assert_eq(want, expected)
    }
    _ => fail("expected UnexpectedSectionType")
  } noraise {
    _ => fail("expected UnexpectedSectionType")
  }
}

///|
fn assert_gnu_abi_tag(
  note : @elf.Note?,
  expected_subminor : UInt,
) -> Unit raise {
  match note {
    Some(GnuAbiTag(tag)) => {
      assert_eq(tag.os, 0U)
      assert_eq(tag.major, 2U)
      assert_eq(tag.minor, 6U)
      assert_eq(tag.subminor, expected_subminor)
    }
    _ => fail("expected GNU ABI tag note")
  }
}

///|
fn assert_gnu_build_id(note : @elf.Note?) -> Unit raise {
  match note {
    Some(GnuBuildId(NoteGnuBuildId(desc))) =>
      assert_eq(
        desc.to_owned(),
        b"\x77\x41\x9f\x0d\xa5\x10\x83\x0c\x57\xa7\xc8\xcc\xb0\xee\x85\x5f\xee\xd3\x76\xa3",
      )
    _ => fail("expected GNU build-id note")
  }
}

///|
test "real file: basic x86_64 headers sections and segments" {
  let elf = parse_testdata("basic.x86_64")
  assert_true(elf.ehdr.class is ELF64)
  assert_true(elf.ehdr.endianness is Little)
  assert_eq(elf.ehdr.e_type, @elf.ET_EXEC)
  assert_eq(elf.ehdr.e_machine, @elf.EM_X86_64)
  let shdrs = unwrap_some(elf.section_headers(), "expected section headers")
  let shdr4 = shdrs.get(4)
  assert_eq(shdr4.sh_type, @elf.SHT_GNU_HASH)
  let (named_shdrs, shstrtab) = elf.section_headers_with_strtab()
  ignore(unwrap_some(named_shdrs, "expected named section headers"))
  let shstrtab = unwrap_some(shstrtab, "expected section string table")
  assert_eq(shstrtab.get(uint_to_int(shdr4.sh_name)), ".gnu.hash")
  let gnu_hash = unwrap_some(
    elf.section_header_by_name(".gnu.hash"),
    "expected .gnu.hash",
  )
  assert_eq(gnu_hash.sh_type, @elf.SHT_GNU_HASH)
  assert_true(elf.section_header_by_name(".not.found") is None)

  let segments = unwrap_some(elf.segments(), "expected program headers")
  let first = segments.get(0)
  assert_eq(first.p_type, @elf.PT_PHDR)
  assert_eq(first.p_offset, 64UL)
  assert_eq(first.p_vaddr, 4194368UL)
  assert_eq(first.p_paddr, 4194368UL)
  assert_eq(first.p_filesz, 448UL)
  assert_eq(first.p_memsz, 448UL)
  assert_eq(first.p_flags, 5U)
  assert_eq(first.p_align, 8UL)
}

///|
test "real file: extended section and program header counts" {
  let shnum_elf = parse_testdata("shnum.x86_64")
  let (shdrs, shstrtab) = shnum_elf.section_headers_with_strtab()
  let shdrs = unwrap_some(shdrs, "expected extended section headers")
  let shstrtab = unwrap_some(shstrtab, "expected extended section string table")
  assert_eq(shdrs.len(), 0xff15)
  let last = shdrs.get(shdrs.len() - 1)
  assert_eq(shstrtab.get(uint_to_int(last.sh_name)), ".shstrtab")
  assert_eq(last.sh_type, @elf.SHT_STRTAB)

  let phnum_elf = parse_testdata("phnum.m68k.so")
  let segments = unwrap_some(phnum_elf.segments(), "expected extended segments")
  let first = segments.get(0)
  assert_eq(first.p_type, @elf.PT_PHDR)
  assert_eq(first.p_offset, 92UL)
  assert_eq(first.p_vaddr, 0UL)
  assert_eq(first.p_paddr, 0UL)
  assert_eq(first.p_filesz, 32UL)
  assert_eq(first.p_memsz, 32UL)
  assert_eq(first.p_flags, 0x20003U)
  assert_eq(first.p_align, 0x40000UL)
}

///|
test "real file: section data symbol tables dynamic table and relocations" {
  let elf = parse_testdata("basic.x86_64")
  let shdrs = unwrap_some(elf.section_headers(), "expected section headers")
  let nobits = shdrs.get(26)
  assert_eq(nobits.sh_type, @elf.SHT_NOBITS)
  let (nobits_data, nobits_compression) = elf.section_data(nobits)
  assert_true(nobits_compression is None)
  assert_eq(nobits_data.to_owned(), b"")

  let versym = shdrs.get(7)
  assert_eq(versym.sh_type, @elf.SHT_GNU_VERSYM)
  let (versym_data, versym_compression) = elf.section_data(versym)
  assert_true(versym_compression is None)
  assert_eq(versym_data.to_owned(), b"\x00\x00\x02\x00\x02\x00\x00\x00")

  let shstrtab = shdrs.get(elf.ehdr.e_shstrndx.to_int())
  let strtab = elf.section_data_as_strtab(shstrtab)
  assert_eq(strtab.get(1), ".symtab")

  let (symtab, symstrs) = unwrap_some(
    elf.symbol_table(),
    "expected static symbol table",
  )
  let symbol = symtab.get(30)
  assert_eq(symbol.st_name, 19U)
  assert_eq(symbol.st_value, 6293200UL)
  assert_eq(symbol.st_size, 0UL)
  assert_eq(symbol.st_shndx, 21)
  assert_eq(symbol.st_info, 1)
  assert_eq(symbol.st_other, 0)
  assert_eq(symstrs.get(uint_to_int(symbol.st_name)), "__JCR_LIST__")

  let (dynsyms, dynstrs) = unwrap_some(
    elf.dynamic_symbol_table(),
    "expected dynamic symbol table",
  )
  let dynsym = dynsyms.get(1)
  assert_eq(dynsym.st_name, 11U)
  assert_eq(dynsym.st_value, 0UL)
  assert_eq(dynsym.st_size, 0UL)
  assert_eq(dynsym.st_shndx, 0)
  assert_eq(dynsym.st_info, 18)
  assert_eq(dynsym.st_other, 0)
  assert_eq(dynstrs.get(uint_to_int(dynsym.st_name)), "memset")

  let dynamic = unwrap_some(elf.dynamic(), "expected dynamic table")
  let first = dynamic.get(0)
  assert_eq(first.d_tag, @elf.DT_NEEDED)
  assert_eq(first.d_un, 1UL)
  let second = dynamic.get(1)
  assert_eq(second.d_tag, @elf.DT_INIT)
  assert_eq(second.d_un, 4195216UL)

  let rela_shdr = shdrs.get(10)
  let relas = elf.section_data_as_relas(rela_shdr)
  let rela0 = relas.get(0)
  assert_eq(rela0.r_offset, 6293704UL)
  assert_eq(rela0.r_sym, 1U)
  assert_eq(rela0.r_type, 7U)
  assert_eq(rela0.r_addend, 0L)
  let rela1 = relas.get(1)
  assert_eq(rela1.r_offset, 6293712UL)
  assert_eq(rela1.r_sym, 2U)
  assert_eq(rela1.r_type, 7U)
  assert_eq(rela1.r_addend, 0L)

  let null_shdr = shdrs.get(0)
  assert_unexpected_section_type(
    fn() raise @elf.ParseError { ignore(elf.section_data_as_strtab(null_shdr)) },
    @elf.SHT_NULL,
    @elf.SHT_STRTAB,
  )
  assert_unexpected_section_type(
    fn() raise @elf.ParseError { ignore(elf.section_data_as_rels(null_shdr)) },
    @elf.SHT_NULL,
    @elf.SHT_REL,
  )
  assert_unexpected_section_type(
    fn() raise @elf.ParseError { ignore(elf.section_data_as_relas(null_shdr)) },
    @elf.SHT_NULL,
    @elf.SHT_RELA,
  )
  assert_unexpected_section_type(
    fn() raise @elf.ParseError { ignore(elf.section_data_as_notes(null_shdr)) },
    @elf.SHT_NULL,
    @elf.SHT_NOTE,
  )
}

///|
test "real file: notes from section and segment data" {
  let elf = parse_testdata("basic.x86_64")
  let shdrs = unwrap_some(elf.section_headers(), "expected section headers")
  let note_shdr = shdrs.get(2)
  let notes = elf.section_data_as_notes(note_shdr)
  assert_gnu_abi_tag(notes.next(), 32U)
  assert_true(notes.next() is None)

  let segments = unwrap_some(elf.segments(), "expected program headers")
  let note_phdr = segments.get(5)
  let segment_notes = elf.segment_data_as_notes(note_phdr)
  assert_gnu_abi_tag(segment_notes.next(), 32U)
  assert_gnu_build_id(segment_notes.next())
  assert_true(segment_notes.next() is None)
}

///|
test "real file: GNU symbol versions and hash lookups" {
  let elf = parse_testdata("symver.x86_64.so")
  let common = elf.find_common_data()
  ignore(unwrap_some(common.symtab, "expected symbol table"))
  ignore(unwrap_some(common.symtab_strs, "expected symbol string table"))
  let dynsyms = unwrap_some(common.dynsyms, "expected dynamic symbols")
  let dynstrs = unwrap_some(common.dynsyms_strs, "expected dynamic strings")
  ignore(unwrap_some(common.dynamic, "expected dynamic section"))
  let sysv_hash = unwrap_some(common.sysv_hash, "expected SysV hash")
  let gnu_hash = unwrap_some(common.gnu_hash, "expected GNU hash")

  assert_eq(@elf.sysv_hash(b"use_memset_v2"[:]), 0x8080542U)
  assert_eq(@elf.sysv_hash(b"__gmon_start__"[:]), 0xf4d007fU)
  assert_eq(@elf.sysv_hash(b"memset"[:]), 0x73c49c4U)
  let (sysv_idx, sysv_sym) = unwrap_some(
    sysv_hash.find(b"memset"[:], dynsyms, dynstrs),
    "expected memset in SysV hash",
  )
  assert_eq(sysv_idx, 2)
  assert_eq(dynstrs.get(uint_to_int(sysv_sym.st_name)), "memset")
  assert_true(sysv_sym == dynsyms.get(sysv_idx))

  let (gnu_idx, gnu_sym) = unwrap_some(
    gnu_hash.find(b"use_memset"[:], dynsyms, dynstrs),
    "expected use_memset in GNU hash",
  )
  assert_eq(gnu_idx, 9)
  assert_eq(dynstrs.get(uint_to_int(gnu_sym.st_name)), "use_memset")
  assert_true(gnu_sym == dynsyms.get(gnu_idx))

  let versions = unwrap_some(
    elf.symbol_version_table(),
    "expected GNU symbol versions",
  )
  let req2 = unwrap_some(versions.get_requirement(2), "expected requirement 2")
  assert_eq(req2.file, "libc.so.6")
  assert_eq(req2.name, "GLIBC_2.2.5")
  assert_eq(req2.hash, 0x9691a75U)
  assert_true(versions.get_requirement(3) is None)
  assert_true(versions.get_requirement(4) is None)
  let req5 = unwrap_some(versions.get_requirement(5), "expected requirement 5")
  assert_eq(req5.file, "libc.so.6")
  assert_eq(req5.name, "GLIBC_2.2.5")
  assert_eq(req5.hash, 0x9691a75U)

  let def3 = unwrap_some(versions.get_definition(3), "expected definition 3")
  assert_eq(def3.hash, 0x0c33237fU)
  assert_eq(def3.flags, 1)
  assert_false(def3.hidden)
  assert_eq(def3.names.length(), 1)
  assert_eq(def3.names[0], "hello.so")

  let def7 = unwrap_some(versions.get_definition(7), "expected definition 7")
  assert_eq(def7.hash, 0x01570b62U)
  assert_eq(def7.flags, 0)
  assert_true(def7.hidden)
  assert_eq(def7.names.length(), 1)
  assert_eq(def7.names[0], "HELLO_1.42")
}

///|
fn assert_real_arch(
  arch : String,
  machine : UInt16,
  endian : @elf.Endian,
) -> Unit raise {
  let elf = parse_testdata("symver." + arch + ".so")
  assert_eq(elf.ehdr.e_machine, machine)
  assert_true(elf.ehdr.endianness == endian)

  let (shdrs, shstrtab) = elf.section_headers_with_strtab()
  let shdrs = unwrap_some(shdrs, "expected section headers")
  let shstrtab = unwrap_some(shstrtab, "expected section string table")
  for i in 0..<shdrs.len() {
    let shdr = shdrs.get(i)
    ignore(shstrtab.get(uint_to_int(shdr.sh_name)))
  }

  let common = elf.find_common_data()
  let symtab = unwrap_some(common.symtab, "expected symbol table")
  let symstrs = unwrap_some(common.symtab_strs, "expected symbol strings")
  for i in 0..<symtab.len() {
    let sym = symtab.get(i)
    ignore(symstrs.get(uint_to_int(sym.st_name)))
  }

  let dynsyms = unwrap_some(common.dynsyms, "expected dynamic symbols")
  let dynstrs = unwrap_some(common.dynsyms_strs, "expected dynamic strings")
  for i in 0..<dynsyms.len() {
    let sym = dynsyms.get(i)
    ignore(dynstrs.get_raw(uint_to_int(sym.st_name)))
  }

  match common.gnu_hash {
    Some(hash_table) => {
      let found = hash_table.find(b"use_memset"[:], dynsyms, dynstrs)
      assert_true(found is Some(_))
    }
    None => ()
  }

  let segments = unwrap_some(elf.segments(), "expected program headers")
  for i in 0..<segments.len() {
    let phdr = segments.get(i)
    if phdr.p_type == @elf.PT_NOTE {
      ignore(elf.segment_data_as_notes(phdr).next())
    }
  }
}

///|
test "real file: symver architecture smoke tests" {
  assert_real_arch("x86_64", @elf.EM_X86_64, Little)
  assert_real_arch("m68k", @elf.EM_68K, Big)
  assert_real_arch("aarch64", @elf.EM_AARCH64, Little)
  assert_real_arch("armhf", @elf.EM_ARM, Little)
  assert_real_arch("powerpc64", @elf.EM_PPC64, Big)
  assert_real_arch("powerpc64le", @elf.EM_PPC64, Little)
  assert_real_arch("riscv64", @elf.EM_RISCV, Little)
}
