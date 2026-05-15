///|
/// Common high-value tables found in an ELF object.
///
/// `find_common_data` fills this structure with any matching sections found by
/// one pass over the section header table. All fields are optional because
/// stripped files, relocatable objects, shared objects, and executables carry
/// different combinations of these tables.
pub(all) struct CommonElfData {
  /// Static `.symtab` symbol table, if present.
  symtab : SymbolTable?
  /// String table linked from `.symtab`, if present.
  symtab_strs : StringTable?
  /// Dynamic `.dynsym` symbol table, if present.
  dynsyms : SymbolTable?
  /// String table linked from `.dynsym`, if present.
  dynsyms_strs : StringTable?
  /// `.dynamic` section or `PT_DYNAMIC` segment, if present.
  dynamic : DynamicTable?
  /// SysV `.hash` table for dynamic symbol lookup, if present.
  sysv_hash : SysVHashTable?
  /// GNU `.gnu.hash` table for dynamic symbol lookup, if present.
  gnu_hash : GnuHashTable?
}

///|
/// Bytes-oriented ELF parser.
///
/// `ElfBytes` owns no copy of the file data. It stores a `BytesView` supplied by
/// the caller, eagerly parses the file header, and lazily wraps the section and
/// program header table byte ranges. Higher-level helpers then expose table
/// views and raw section/segment bytes from the same source data.
pub(all) struct ElfBytes {
  /// Parsed ELF file header.
  ehdr : FileHeader
  /// Original file bytes.
  data : BytesView
  /// Lazy section-header table, absent when `e_shoff == 0`.
  shdrs : SectionHeaderTable?
  /// Lazy program-header table, absent when `e_phoff == 0`.
  phdrs : SegmentTable?
}

///|
fn find_shdrs(
  ehdr : FileHeader,
  data : BytesView,
) -> SectionHeaderTable? raise ParseError {
  // ELF files are allowed to omit the section header table.
  if ehdr.e_shoff == 0UL {
    return None
  }
  let shoff = u64_to_int_checked(ehdr.e_shoff)
  let mut shnum = ehdr.e_shnum.to_int()
  if shnum == 0 {
    // Extended section counts are stored in section header 0's `sh_size`.
    let (shdr0, _) = SectionHeader::parse_at(
      ehdr.endianness,
      ehdr.class,
      shoff,
      data,
    )
    shnum = u64_to_int_checked(shdr0.sh_size)
  }
  // Validate the on-disk entry size before wrapping the table. This catches
  // corrupt files early and keeps lazy entry parsing aligned.
  let entsize = validate_entsize(
    ehdr.e_shentsize.to_int(),
    SectionHeader::size_for(ehdr.class),
  )
  let size = checked_mul(entsize, shnum)
  let end = checked_add(shoff, size)
  Some(
    SectionHeaderTable(
      ehdr.endianness,
      ehdr.class,
      slice_checked(data, shoff, end),
    ),
  )
}

///|
fn find_phdrs(
  ehdr : FileHeader,
  data : BytesView,
) -> SegmentTable? raise ParseError {
  // ELF files are allowed to omit the program header table.
  if ehdr.e_phoff == 0UL {
    return None
  }
  let mut phnum = ehdr.e_phnum.to_int()
  if ehdr.e_phnum == PN_XNUM {
    // Extended program-header counts are stored in section header 0's `sh_info`.
    let shoff = u64_to_int_checked(ehdr.e_shoff)
    let (shdr0, _) = SectionHeader::parse_at(
      ehdr.endianness,
      ehdr.class,
      shoff,
      data,
    )
    phnum = uint_to_int_checked(shdr0.sh_info)
  }
  // Validate the on-disk entry size before wrapping the table.
  let entsize = validate_entsize(
    ehdr.e_phentsize.to_int(),
    ProgramHeader::size_for(ehdr.class),
  )
  let phoff = u64_to_int_checked(ehdr.e_phoff)
  let size = checked_mul(entsize, phnum)
  let end = checked_add(phoff, size)
  Some(
    SegmentTable(ehdr.endianness, ehdr.class, slice_checked(data, phoff, end)),
  )
}

///|
/// Parse the minimum metadata needed to inspect an ELF file.
///
/// This validates the ELF identity, parses the `FileHeader`, and locates the
/// section and program header tables without parsing every table entry.
pub fn ElfBytes::minimal_parse(data : BytesView) -> ElfBytes raise ParseError {
  let ident_buf = slice_checked(data, 0, EI_NIDENT)
  let ident = parse_ident(ident_buf)
  let (_, class, _, _) = ident
  let tail_start = EI_NIDENT
  let tail_size = match class {
    ELF32 => ELF32_EHDR_TAILSIZE
    ELF64 => ELF64_EHDR_TAILSIZE
  }
  let tail_end = checked_add(tail_start, tail_size)
  let tail_buf = slice_checked(data, tail_start, tail_end)
  let ehdr = FileHeader::parse_tail(ident, tail_buf)
  let shdrs = find_shdrs(ehdr, data)
  let phdrs = find_phdrs(ehdr, data)
  { ehdr, data, shdrs, phdrs }
}

///|
/// Return the lazy program-header table, if the file has one.
pub fn ElfBytes::segments(self : ElfBytes) -> SegmentTable? {
  self.phdrs
}

///|
/// Return the lazy section-header table, if the file has one.
pub fn ElfBytes::section_headers(self : ElfBytes) -> SectionHeaderTable? {
  self.shdrs
}

///|
/// Return section headers and their section-name string table.
///
/// If the file has section headers but no section-name string table, returns
/// `(Some(shdrs), None)`. Extended `e_shstrndx` values are resolved through
/// section header 0.
pub fn ElfBytes::section_headers_with_strtab(
  self : ElfBytes,
) -> (SectionHeaderTable?, StringTable?) raise ParseError {
  let shdrs = match self.section_headers() {
    Some(shdrs) => shdrs
    None => return (None, None)
  }
  if self.ehdr.e_shstrndx == SHN_UNDEF {
    return (Some(shdrs), None)
  }
  let mut shstrndx = self.ehdr.e_shstrndx.to_int()
  if self.ehdr.e_shstrndx == SHN_XINDEX {
    // Extended section-name string table index is in section header 0's `sh_link`.
    shstrndx = uint_to_int_checked(shdrs.get(0).sh_link)
  }
  let strtab = shdrs.get(shstrndx)
  let (start, end) = strtab.get_data_range()
  (Some(shdrs), Some(StringTable::new(slice_checked(self.data, start, end))))
}

///|
/// Find a section header by its name.
///
/// Returns `None` when the object has no section headers, no section-name
/// string table, or no matching section. Malformed string table entries are
/// skipped while searching.
pub fn ElfBytes::section_header_by_name(
  self : ElfBytes,
  name : String,
) -> SectionHeader? raise ParseError {
  let (shdrs_opt, strtab_opt) = self.section_headers_with_strtab()
  let (shdrs, strtab) = match (shdrs_opt, strtab_opt) {
    (Some(shdrs), Some(strtab)) => (shdrs, strtab)
    _ => return None
  }
  for shdr in shdrs.iter() {
    try strtab.get(uint_to_int_checked(shdr.sh_name)) catch {
      _ => ()
    } noraise {
      section_name => if section_name == name { return Some(shdr) }
    }
  }
  None
}

///|
/// Return raw data for a section.
///
/// `SHT_NOBITS` sections occupy no bytes in the file and return an empty view.
/// For compressed sections, the returned byte view starts after the parsed
/// `CompressionHeader`.
pub fn ElfBytes::section_data(
  self : ElfBytes,
  shdr : SectionHeader,
) -> (BytesView, CompressionHeader?) raise ParseError {
  if shdr.sh_type == SHT_NOBITS {
    return (b""[:], None)
  }
  let (start, end) = shdr.get_data_range()
  let buf = slice_checked(self.data, start, end)
  if (shdr.sh_flags & SHF_COMPRESSED.to_uint64()) == 0UL {
    (buf, None)
  } else {
    let (chdr, offset) = CompressionHeader::parse_at(
      self.ehdr.endianness,
      self.ehdr.class,
      0,
      buf,
    )
    (tail_checked(buf, offset), Some(chdr))
  }
}

///|
/// Interpret section data as a string table.
///
/// Raises `UnexpectedSectionType` unless `shdr.sh_type == SHT_STRTAB`.
pub fn ElfBytes::section_data_as_strtab(
  self : ElfBytes,
  shdr : SectionHeader,
) -> StringTable raise ParseError {
  if shdr.sh_type != SHT_STRTAB {
    raise UnexpectedSectionType(shdr.sh_type, SHT_STRTAB)
  }
  let (buf, _) = self.section_data(shdr)
  StringTable::new(buf)
}

///|
/// Interpret section data as no-addend relocation entries.
///
/// Raises `UnexpectedSectionType` unless `shdr.sh_type == SHT_REL`.
pub fn ElfBytes::section_data_as_rels(
  self : ElfBytes,
  shdr : SectionHeader,
) -> RelIterator raise ParseError {
  if shdr.sh_type != SHT_REL {
    raise UnexpectedSectionType(shdr.sh_type, SHT_REL)
  }
  if shdr.sh_entsize != 0UL {
    ignore(
      validate_entsize(
        u64_to_int_checked(shdr.sh_entsize),
        Rel::size_for(self.ehdr.class),
      ),
    )
  }
  let (buf, _) = self.section_data(shdr)
  RelIterator(self.ehdr.endianness, self.ehdr.class, buf)
}

///|
/// Interpret section data as addend relocation entries.
///
/// Raises `UnexpectedSectionType` unless `shdr.sh_type == SHT_RELA`.
pub fn ElfBytes::section_data_as_relas(
  self : ElfBytes,
  shdr : SectionHeader,
) -> RelaIterator raise ParseError {
  if shdr.sh_type != SHT_RELA {
    raise UnexpectedSectionType(shdr.sh_type, SHT_RELA)
  }
  if shdr.sh_entsize != 0UL {
    ignore(
      validate_entsize(
        u64_to_int_checked(shdr.sh_entsize),
        Rela::size_for(self.ehdr.class),
      ),
    )
  }
  let (buf, _) = self.section_data(shdr)
  RelaIterator(self.ehdr.endianness, self.ehdr.class, buf)
}

///|
/// Interpret section data as ELF notes.
///
/// Raises `UnexpectedSectionType` unless `shdr.sh_type == SHT_NOTE`.
pub fn ElfBytes::section_data_as_notes(
  self : ElfBytes,
  shdr : SectionHeader,
) -> NoteIterator raise ParseError {
  if shdr.sh_type != SHT_NOTE {
    raise UnexpectedSectionType(shdr.sh_type, SHT_NOTE)
  }
  let (buf, _) = self.section_data(shdr)
  NoteIterator::new(
    self.ehdr.endianness,
    self.ehdr.class,
    u64_to_int_checked(shdr.sh_addralign),
    buf,
  )
}

///|
// Internal dynamic-section adapter used by `dynamic` and `find_common_data`.
fn ElfBytes::section_data_as_dynamic(
  self : ElfBytes,
  shdr : SectionHeader,
) -> DynamicTable raise ParseError {
  if shdr.sh_type != SHT_DYNAMIC {
    raise UnexpectedSectionType(shdr.sh_type, SHT_DYNAMIC)
  }
  ignore(
    validate_entsize(
      u64_to_int_checked(shdr.sh_entsize),
      Dyn::size_for(self.ehdr.class),
    ),
  )
  let (buf, _) = self.section_data(shdr)
  DynamicTable(self.ehdr.endianness, self.ehdr.class, buf)
}

///|
/// Return the bytes occupied by a program segment in the file.
pub fn ElfBytes::segment_data(
  self : ElfBytes,
  phdr : ProgramHeader,
) -> BytesView raise ParseError {
  let (start, end) = phdr.get_file_data_range()
  slice_checked(self.data, start, end)
}

///|
/// Interpret segment data as ELF notes.
///
/// Raises `UnexpectedSegmentType` unless `phdr.p_type == PT_NOTE`.
pub fn ElfBytes::segment_data_as_notes(
  self : ElfBytes,
  phdr : ProgramHeader,
) -> NoteIterator raise ParseError {
  if phdr.p_type != PT_NOTE {
    raise UnexpectedSegmentType(phdr.p_type, PT_NOTE)
  }
  NoteIterator::new(
    self.ehdr.endianness,
    self.ehdr.class,
    u64_to_int_checked(phdr.p_align),
    self.segment_data(phdr),
  )
}

///|
/// Return the `.dynamic` table, if present.
///
/// Section headers are preferred when available. If the file has no section
/// headers, the parser falls back to the `PT_DYNAMIC` program segment.
pub fn ElfBytes::dynamic(self : ElfBytes) -> DynamicTable? raise ParseError {
  match self.section_headers() {
    Some(shdrs) =>
      for shdr in shdrs.iter() {
        if shdr.sh_type == SHT_DYNAMIC {
          return Some(self.section_data_as_dynamic(shdr))
        }
      }
    None =>
      match self.segments() {
        Some(phdrs) =>
          for phdr in phdrs.iter() {
            if phdr.p_type == PT_DYNAMIC {
              let (start, end) = phdr.get_file_data_range()
              return Some(
                DynamicTable(
                  self.ehdr.endianness,
                  self.ehdr.class,
                  slice_checked(self.data, start, end),
                ),
              )
            }
          }
        None => ()
      }
  }
  None
}

///|
// Shared helper for `.symtab` and `.dynsym`; both sections link to their
// corresponding string table through `sh_link`.
fn ElfBytes::section_data_as_symbol_table(
  self : ElfBytes,
  shdr : SectionHeader,
  strtab_shdr : SectionHeader,
) -> (SymbolTable, StringTable) raise ParseError {
  ignore(
    validate_entsize(
      u64_to_int_checked(shdr.sh_entsize),
      Symbol::size_for(self.ehdr.class),
    ),
  )
  // Load both the symbol table and the linked string table from the original
  // bytes so callers can keep the two lazy views together.
  let (symtab_start, symtab_end) = shdr.get_data_range()
  let symtab_buf = slice_checked(self.data, symtab_start, symtab_end)
  let (strtab_start, strtab_end) = strtab_shdr.get_data_range()
  let strtab_buf = slice_checked(self.data, strtab_start, strtab_end)
  (
    SymbolTable(self.ehdr.endianness, self.ehdr.class, symtab_buf),
    StringTable::new(strtab_buf),
  )
}

///|
/// Return the file's static `.symtab` and its linked string table, if present.
pub fn ElfBytes::symbol_table(
  self : ElfBytes,
) -> (SymbolTable, StringTable)? raise ParseError {
  let shdrs = match self.section_headers() {
    Some(shdrs) => shdrs
    None => return None
  }
  for shdr in shdrs.iter() {
    if shdr.sh_type == SHT_SYMTAB {
      return Some(
        self.section_data_as_symbol_table(
          shdr,
          shdrs.get(uint_to_int_checked(shdr.sh_link)),
        ),
      )
    }
  }
  None
}

///|
/// Return the file's dynamic `.dynsym` and its linked string table, if present.
pub fn ElfBytes::dynamic_symbol_table(
  self : ElfBytes,
) -> (SymbolTable, StringTable)? raise ParseError {
  let shdrs = match self.section_headers() {
    Some(shdrs) => shdrs
    None => return None
  }
  for shdr in shdrs.iter() {
    if shdr.sh_type == SHT_DYNSYM {
      return Some(
        self.section_data_as_symbol_table(
          shdr,
          shdrs.get(uint_to_int_checked(shdr.sh_link)),
        ),
      )
    }
  }
  None
}

///|
/// Locate common ELF data tables in one pass over the section headers.
///
/// This is useful when a caller expects to inspect several common structures:
/// symbol tables, string tables, dynamic entries, and hash tables. If no
/// `SHT_DYNAMIC` section is found, the method also checks for `PT_DYNAMIC`.
pub fn ElfBytes::find_common_data(
  self : ElfBytes,
) -> CommonElfData raise ParseError {
  let mut symtab : SymbolTable? = None
  let mut symtab_strs : StringTable? = None
  let mut dynsyms : SymbolTable? = None
  let mut dynsyms_strs : StringTable? = None
  let mut dynamic : DynamicTable? = None
  let mut sysv_hash_table : SysVHashTable? = None
  let mut gnu_hash_table : GnuHashTable? = None
  match self.shdrs {
    Some(shdrs) =>
      // Collect known table-like sections while scanning section headers once.
      for shdr in shdrs.iter() {
        match shdr.sh_type {
          SHT_SYMTAB => {
            let (table, strs) = self.section_data_as_symbol_table(
              shdr,
              shdrs.get(uint_to_int_checked(shdr.sh_link)),
            )
            symtab = Some(table)
            symtab_strs = Some(strs)
          }
          SHT_DYNSYM => {
            let (table, strs) = self.section_data_as_symbol_table(
              shdr,
              shdrs.get(uint_to_int_checked(shdr.sh_link)),
            )
            dynsyms = Some(table)
            dynsyms_strs = Some(strs)
          }
          SHT_DYNAMIC => dynamic = Some(self.section_data_as_dynamic(shdr))
          SHT_HASH => {
            let (start, end) = shdr.get_data_range()
            sysv_hash_table = Some(
              SysVHashTable::new(
                self.ehdr.endianness,
                self.ehdr.class,
                slice_checked(self.data, start, end),
              ),
            )
          }
          SHT_GNU_HASH => {
            let (start, end) = shdr.get_data_range()
            gnu_hash_table = Some(
              GnuHashTable::new(
                self.ehdr.endianness,
                self.ehdr.class,
                slice_checked(self.data, start, end),
              ),
            )
          }
          _ => ()
        }
      }
    None => ()
  }
  if dynamic is None {
    match self.phdrs {
      Some(phdrs) =>
        // Stripped or unusual objects may expose dynamic data only through a
        // program segment.
        for phdr in phdrs.iter() {
          if phdr.p_type == PT_DYNAMIC {
            let (start, end) = phdr.get_file_data_range()
            dynamic = Some(
              DynamicTable(
                self.ehdr.endianness,
                self.ehdr.class,
                slice_checked(self.data, start, end),
              ),
            )
            break
          }
        }
      None => ()
    }
  }
  {
    symtab,
    symtab_strs,
    dynsyms,
    dynsyms_strs,
    dynamic,
    sysv_hash: sysv_hash_table,
    gnu_hash: gnu_hash_table,
  }
}

///|
/// Locate GNU symbol-versioning data, if the object uses it.
///
/// Returns a `SymbolVersionTable` that can map dynamic-symbol indices to
/// version requirements (`.gnu.version_r`) and definitions (`.gnu.version_d`).
/// GNU symbol versioning is optional, so files without `.gnu.version` return
/// `None`.
pub fn ElfBytes::symbol_version_table(
  self : ElfBytes,
) -> SymbolVersionTable? raise ParseError {
  let shdrs = match self.section_headers() {
    Some(shdrs) => shdrs
    None => return None
  }
  let mut versym_opt : SectionHeader? = None
  let mut needs_opt : SectionHeader? = None
  let mut defs_opt : SectionHeader? = None
  for shdr in shdrs.iter() {
    if shdr.sh_type == SHT_GNU_VERSYM {
      versym_opt = Some(shdr)
    } else if shdr.sh_type == SHT_GNU_VERNEED {
      needs_opt = Some(shdr)
    } else if shdr.sh_type == SHT_GNU_VERDEF {
      defs_opt = Some(shdr)
    }
  }
  let versym = match versym_opt {
    Some(shdr) => shdr
    None => return None
  }
  // `.gnu.version` has one 16-bit version index per dynamic symbol.
  ignore(
    validate_entsize(
      u64_to_int_checked(versym.sh_entsize),
      VersionIndex::size_for(self.ehdr.class),
    ),
  )
  let (versym_start, versym_end) = versym.get_data_range()
  let version_ids = VersionIndexTable(
    self.ehdr.endianness,
    self.ehdr.class,
    slice_checked(self.data, versym_start, versym_end),
  )
  let verneeds = match needs_opt {
    Some(shdr) => {
      // Version requirements carry library and version-name offsets into the
      // string table linked by the section header.
      let (start, end) = shdr.get_data_range()
      let strs_shdr = shdrs.get(uint_to_int_checked(shdr.sh_link))
      let (strs_start, strs_end) = strs_shdr.get_data_range()
      Some(
        (
          VerNeedIterator::new(
            self.ehdr.endianness,
            self.ehdr.class,
            shdr.sh_info.to_uint64(),
            0,
            slice_checked(self.data, start, end),
          ),
          StringTable::new(slice_checked(self.data, strs_start, strs_end)),
        ),
      )
    }
    None => None
  }
  let verdefs = match defs_opt {
    Some(shdr) => {
      // Version definitions also refer to names in their linked string table.
      let (start, end) = shdr.get_data_range()
      let strs_shdr = shdrs.get(uint_to_int_checked(shdr.sh_link))
      let (strs_start, strs_end) = strs_shdr.get_data_range()
      Some(
        (
          VerDefIterator::new(
            self.ehdr.endianness,
            self.ehdr.class,
            shdr.sh_info.to_uint64(),
            0,
            slice_checked(self.data, start, end),
          ),
          StringTable::new(slice_checked(self.data, strs_start, strs_end)),
        ),
      )
    }
    None => None
  }
  Some(SymbolVersionTable::new(version_ids, verneeds, verdefs))
}
