# moonbit-community/elf

`moonbit-community/elf` is a MoonBit library for reading ELF object files.

## Capabilities

- Parses both `ELFCLASS32` and `ELFCLASS64` files.
- Handles little-endian and big-endian ELF data through the parsed
  `Endian` value.
- Keeps table parsing lazy: `SectionHeaderTable`, `SegmentTable`,
  `SymbolTable`, `DynamicTable`, and version iterators parse entries on demand.
- Provides checked offset arithmetic and returns `ParseError` for malformed or
  truncated input instead of reading outside the supplied byte slice.
- Exposes helpers for common sections and segments: string tables,
  relocations, notes, symbol tables, `.dynamic`, SysV `.hash`, GNU `.gnu.hash`,
  and GNU symbol versioning.
- Returns raw section and segment byte views. Compressed sections are identified
  and their `CompressionHeader` is returned, but decompression is intentionally
  left to the caller.

## Quick Start

The main entry point is `ElfBytes::minimal_parse`. It reads enough of the file
to validate the ELF identity, parse the file header, and locate the optional
section and program header tables.

```mbt check
///|
test "readme quick start" {
  let data = @fs.read_file_to_bytes("testdata/basic.x86_64")
  let elf = @elf.ElfBytes::minimal_parse(data[:])

  assert_true(elf.ehdr.class is ELF64)
  assert_true(elf.ehdr.endianness is Little)
  assert_eq(elf.ehdr.e_machine, @elf.EM_X86_64)

  let text = match elf.section_header_by_name(".text") {
    Some(shdr) => shdr
    None => fail("expected .text section")
  }
  let (bytes, compression) = elf.section_data(text)
  assert_true(bytes.length() > 0)
  assert_true(compression is None)
}
```

## Common Data

Use `find_common_data` when you need several standard ELF tables. It performs
one pass over the section headers and collects the tables that are present.

```mbt check
///|
test "readme common data" {
  let data = @fs.read_file_to_bytes("testdata/symver.x86_64.so")
  let elf = @elf.ElfBytes::minimal_parse(data[:])
  let common = elf.find_common_data()

  let dynsyms = match common.dynsyms {
    Some(table) => table
    None => fail("expected dynamic symbol table")
  }
  let dynstrs = match common.dynsyms_strs {
    Some(table) => table
    None => fail("expected dynamic symbol strings")
  }
  let hash = match common.sysv_hash {
    Some(table) => table
    None => fail("expected SysV hash table")
  }

  let (index, symbol) = match hash.find(b"memset"[:], dynsyms, dynstrs) {
    Some(pair) => pair
    None => fail("expected memset")
  }
  assert_eq(index, 2)
  assert_eq(dynstrs.get(symbol.st_name.reinterpret_as_int()), "memset")
}
```

## Parsing Model

`ElfBytes` keeps a view of the original file bytes. Most accessors either
return raw `BytesView` values or a lazy table wrapper over a subrange of those
bytes. Calling `get(index)` parses just that entry, and calling `iter()` parses
as iteration advances.

This has two important consequences:

1. Errors can occur when a table entry is requested, not only when the file is
   opened.
2. You can cheaply obtain several views over the same file, such as a dynamic
   symbol table, its linked string table, and a hash table.

When you need the exact error for a table entry, call `get(index)`. Lazy
iterators such as `ParsingTable::iter()` and `NoteIterator` stop at malformed
input instead of exposing the parse error through the iterator item. Name
lookups also skip section names that cannot be decoded.

## Error Handling

Operations that inspect offsets, sizes, versions, section kinds, or string
contents raise `ParseError`. Use entry-specific accessors such as
`ParsingTable::get(index)` when callers need the exact failure; iterator-style
helpers stop at malformed entries. The most common variants are:

- `BadMagic` for bytes that do not start with `0x7f, 'E', 'L', 'F'`.
- `UnsupportedElfClass` and `UnsupportedElfEndianness` for unknown identity
  bytes.
- `BadOffset` for logical table indices or string-table offsets that are out of
  bounds.
- `SliceReadError` for truncated files or raw byte ranges that cannot be sliced
  from the supplied data.
- `BadEntsize` when a table declares an entry size that does not match the ELF
  class.
- `UnexpectedSectionType` and `UnexpectedSegmentType` when a helper is used on
  the wrong kind of section or segment.
- `StringTableMissingNul` and `Utf8Error` for malformed string table data.

## API Map

| Area | Types and helpers |
| --- | --- |
| File header | `ElfBytes`, `FileHeader`, `Class`, `Endian` |
| Sections | `SectionHeader`, `SectionHeaderTable`, `section_header_by_name`, `section_data*` |
| Segments | `ProgramHeader`, `SegmentTable`, `segment_data*` |
| Symbols | `Symbol`, `SymbolTable`, `symbol_table`, `dynamic_symbol_table` |
| Dynamic linking | `Dyn`, `DynamicTable`, `dynamic` |
| Relocations | `Rel`, `Rela`, `RelIterator`, `RelaIterator` |
| Notes | `Note`, `NoteGnuAbiTag`, `NoteGnuBuildId`, `NoteAny`, `NoteIterator` |
| Hash tables | `sysv_hash`, `gnu_hash`, `SysVHashTable`, `GnuHashTable` |
| GNU versions | `SymbolVersionTable`, `VersionIndex`, `VerDef*`, `VerNeed*` |
| ABI constants | `ET_*`, `EM_*`, `SHT_*`, `PT_*`, `DT_*`, `STB_*`, `STT_*`, and related values |

## Notes

The parser intentionally does not decompress compressed section contents, build
secondary indexes, or interpret every processor-specific ABI value. It exposes
the raw fields and the common cross-platform helpers so callers can decide how
much policy to layer on top.
