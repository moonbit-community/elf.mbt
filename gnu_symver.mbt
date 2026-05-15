///|
/// Lazy table of GNU symbol-version indices from `.gnu.version`.
///
/// This table has the same number of entries as the dynamic symbol table. Entry
/// `N` describes the version requirement or definition associated with dynamic
/// symbol `N`.
pub struct VersionIndexTable {
  table : ParsingTable[VersionIndex]
}

///|
fn VersionIndexTable::VersionIndexTable(
  endian : Endian,
  class : Class,
  data : BytesView,
) -> VersionIndexTable {
  {
    table: ParsingTable(
      endian,
      class,
      data,
      VersionIndex::size_for(class),
      VersionIndex::parse_at,
    ),
  }
}

///|
/// Number of version-index entries.
pub fn VersionIndexTable::len(self : VersionIndexTable) -> Int {
  self.table.len()
}

///|
/// Returns `true` when there are no version-index entries.
pub fn VersionIndexTable::is_empty(self : VersionIndexTable) -> Bool {
  self.table.is_empty()
}

///|
/// Parse the version index for dynamic symbol `index`.
pub fn VersionIndexTable::get(
  self : VersionIndexTable,
  index : Int,
) -> VersionIndex raise ParseError {
  self.table.get(index)
}

///|
/// Iterate over version indices lazily.
pub fn VersionIndexTable::iter(self : VersionIndexTable) -> Iter[VersionIndex] {
  self.table.iter()
}

///|
/// Resolved GNU symbol-version requirement.
///
/// A requirement describes a dynamic symbol that must be provided by another
/// shared object with a specific version name.
pub(all) struct SymbolRequirement {
  /// Required shared object file name, such as `libc.so.6`.
  file : String
  /// Required version name, such as `GLIBC_2.2.5`.
  name : String
  /// SysV ELF hash of the version name.
  hash : UInt
  /// Version requirement flags (`VER_FLG_*`).
  flags : UInt16
  /// Whether the version index has the `VER_NDX_HIDDEN` bit set.
  hidden : Bool
} derive(Debug, Eq)

///|
/// Resolved GNU symbol-version definition.
///
/// A definition describes a version exported by the current object. Multiple
/// names may be associated with one definition through auxiliary entries.
pub(all) struct SymbolDefinition {
  /// SysV ELF hash of the primary version name.
  hash : UInt
  /// Version definition flags (`VER_FLG_*`).
  flags : UInt16
  /// Version or dependency names from linked auxiliary entries.
  names : Array[String]
  /// Whether the version index has the `VER_NDX_HIDDEN` bit set.
  hidden : Bool
} derive(Debug, Eq)

///|
/// Resolver for GNU symbol versioning tables.
///
/// The table combines `.gnu.version` with optional `.gnu.version_r` and
/// `.gnu.version_d` data plus their linked string tables.
pub struct SymbolVersionTable {
  /// Per-dynamic-symbol version indices.
  version_ids : VersionIndexTable
  /// Version requirements and linked strings, if the object imports versions.
  verneeds : VersionNeedData?
  /// Version definitions and linked strings, if the object exports versions.
  verdefs : VersionDefData?
}

///|
struct VersionNeedData {
  iter : VerNeedIterator
  strtab : StringTable
}

///|
struct VersionDefData {
  iter : VerDefIterator
  strtab : StringTable
}

///|
/// Construct a symbol-version resolver from parsed component tables.
pub fn SymbolVersionTable::new(
  version_ids : VersionIndexTable,
  verneeds : (VerNeedIterator, StringTable)?,
  verdefs : (VerDefIterator, StringTable)?,
) -> SymbolVersionTable {
  let verneeds = match verneeds {
    Some((iter, strtab)) => {
      let data : VersionNeedData = { iter, strtab }
      Some(data)
    }
    None => None
  }
  let verdefs = match verdefs {
    Some((iter, strtab)) => {
      let data : VersionDefData = { iter, strtab }
      Some(data)
    }
    None => None
  }
  { version_ids, verneeds, verdefs }
}

///|
/// Resolve the version requirement for dynamic symbol `sym_idx`.
///
/// Returns `None` when the symbol has no imported version requirement or the
/// object has no `.gnu.version_r` section.
pub fn SymbolVersionTable::get_requirement(
  self : SymbolVersionTable,
  sym_idx : Int,
) -> SymbolRequirement? raise ParseError {
  let data = match self.verneeds {
    Some(data) => data
    None => return None
  }
  let ver_ndx = self.version_ids.get(sym_idx)
  // Walk every needed library and its auxiliary version records until the
  // `vna_other` version index matches `.gnu.version[sym_idx]`.
  for item in data.iter.copy().iter() {
    let (vn, vna_iter) = item
    for vna in vna_iter.iter() {
      if vna.vna_other == ver_ndx.index() {
        return Some({
          file: data.strtab.get(uint_to_int_checked(vn.vn_file)),
          name: data.strtab.get(uint_to_int_checked(vna.vna_name)),
          hash: vna.vna_hash,
          flags: vna.vna_flags,
          hidden: ver_ndx.is_hidden(),
        })
      }
    }
  }
  None
}

///|
/// Resolve the version definition for dynamic symbol `sym_idx`.
///
/// Returns `None` when the symbol has no exported version definition or the
/// object has no `.gnu.version_d` section.
pub fn SymbolVersionTable::get_definition(
  self : SymbolVersionTable,
  sym_idx : Int,
) -> SymbolDefinition? raise ParseError {
  let data = match self.verdefs {
    Some(data) => data
    None => return None
  }
  let ver_ndx = self.version_ids.get(sym_idx)
  // Definition records are keyed by `vd_ndx`, which corresponds to the masked
  // `.gnu.version[sym_idx]` value.
  for item in data.iter.copy().iter() {
    let (vd, vda_iter) = item
    if vd.vd_ndx != ver_ndx.index() {
      continue
    }
    let names : Array[String] = []
    for vda in vda_iter.iter() {
      names.push(data.strtab.get(uint_to_int_checked(vda.vda_name)))
    }
    return Some({
      hash: vd.vd_hash,
      flags: vd.vd_flags,
      names,
      hidden: ver_ndx.is_hidden(),
    })
  }
  None
}

///|
/// Raw 16-bit entry from `.gnu.version`.
///
/// The low bits identify local/global/specific versions. The high hidden bit
/// indicates that references should bind to an exact version.
pub(all) struct VersionIndex(UInt16) derive(Debug, Eq)

///|
/// Return the version identifier with the hidden bit masked out.
pub fn VersionIndex::index(self : VersionIndex) -> UInt16 {
  self.0 & VER_NDX_VERSION
}

///|
/// Returns `true` for the special local version index.
pub fn VersionIndex::is_local(self : VersionIndex) -> Bool {
  self.index() == VER_NDX_LOCAL
}

///|
/// Returns `true` for the special global version index.
pub fn VersionIndex::is_global(self : VersionIndex) -> Bool {
  self.index() == VER_NDX_GLOBAL
}

///|
/// Returns `true` when the `VER_NDX_HIDDEN` bit is set.
pub fn VersionIndex::is_hidden(self : VersionIndex) -> Bool {
  (self.0 & VER_NDX_HIDDEN) != 0
}

///|
impl ParseAt for VersionIndex with parse_at(endian, _class, offset, data) {
  let end = checked_add(offset, VersionIndex::size_for(ELF32))
  let record = slice_checked(data, offset, end)
  let value = match endian {
    Little =>
      match record {
        [u16le(value)] => value.to_uint16()
        _ => raise SliceReadError(offset, end)
      }
    Big =>
      match record {
        [u16be(value)] => value.to_uint16()
        _ => raise SliceReadError(offset, end)
      }
  }
  (VersionIndex(value), end)
}

///|
/// Size in bytes of one `.gnu.version` entry.
pub fn VersionIndex::size_for(_class : Class) -> Int {
  2
}

///|
/// Version definition record from `.gnu.version_d`.
///
/// The section describes versions exported by the current object. Auxiliary
/// records reachable through `vd_aux` provide one or more version names.
pub(all) struct VerDef {
  /// Version definition flags.
  vd_flags : UInt16
  /// Version index referenced by `.gnu.version`.
  vd_ndx : UInt16
  /// Number of associated `VerDefAux` records.
  vd_cnt : UInt16
  /// SysV ELF hash of the version name.
  vd_hash : UInt
  /// Offset from this record to the first `VerDefAux`.
  vd_aux : UInt
  /// Offset from this record to the next `VerDef`, or zero to stop.
  vd_next : UInt
} derive(Debug, Eq)

///|
impl ParseAt for VerDef with parse_at(endian, _class, offset, data) {
  let end = checked_add(offset, VerDef::size_for(ELF32))
  let record = slice_checked(data, offset, end)
  let (vd_version, value) = match endian {
    Little =>
      match record {
        [
          u16le(vd_version),
          u16le(vd_flags),
          u16le(vd_ndx),
          u16le(vd_cnt),
          u32le(vd_hash),
          u32le(vd_aux),
          u32le(vd_next),
        ] =>
          (
            vd_version.to_uint16(),
            {
              vd_flags: vd_flags.to_uint16(),
              vd_ndx: vd_ndx.to_uint16(),
              vd_cnt: vd_cnt.to_uint16(),
              vd_hash,
              vd_aux,
              vd_next,
            },
          )
        _ => raise SliceReadError(offset, end)
      }
    Big =>
      match record {
        [
          u16be(vd_version),
          u16be(vd_flags),
          u16be(vd_ndx),
          u16be(vd_cnt),
          u32be(vd_hash),
          u32be(vd_aux),
          u32be(vd_next),
        ] =>
          (
            vd_version.to_uint16(),
            {
              vd_flags: vd_flags.to_uint16(),
              vd_ndx: vd_ndx.to_uint16(),
              vd_cnt: vd_cnt.to_uint16(),
              vd_hash,
              vd_aux,
              vd_next,
            },
          )
        _ => raise SliceReadError(offset, end)
      }
  }
  if vd_version != VER_DEF_CURRENT {
    raise UnsupportedVersion(
      vd_version.to_uint64(),
      VER_DEF_CURRENT.to_uint64(),
    )
  }
  (value, end)
}

///|
/// Size in bytes of one version-definition record.
pub fn VerDef::size_for(_class : Class) -> Int {
  20
}

///|
/// Iterator over `VerDef` records and their auxiliary-name iterators.
pub struct VerDefIterator {
  /// Byte order used to parse records.
  endian : Endian
  /// ELF class of the owning object.
  class : Class
  /// Remaining number of definition records to inspect.
  mut count : UInt64
  /// Raw `.gnu.version_d` bytes.
  data : BytesView
  /// Current offset in `data`.
  mut offset : Int
}

///|
/// Create a version-definition iterator.
pub fn VerDefIterator::new(
  endian : Endian,
  class : Class,
  count : UInt64,
  starting_offset : Int,
  data : BytesView,
) -> VerDefIterator {
  { endian, class, count, data, offset: starting_offset }
}

///|
fn VerDefIterator::copy(self : VerDefIterator) -> VerDefIterator {
  {
    endian: self.endian,
    class: self.class,
    count: self.count,
    data: self.data,
    offset: self.offset,
  }
}

///|
/// Parse the next `VerDef` and create an iterator over its auxiliary records.
pub fn VerDefIterator::next(
  self : VerDefIterator,
) -> (VerDef, VerDefAuxIterator)? {
  if self.data.is_empty() || self.count == 0UL {
    return None
  }
  try VerDef::parse_at(self.endian, self.class, self.offset, self.data) catch {
    _ => {
      self.count = 0UL
      None
    }
  } noraise {
    (vd, _) => {
      let aux_offset = try
        checked_add(self.offset, uint_to_int_checked(vd.vd_aux))
      catch {
        _ => {
          self.count = 0UL
          return None
        }
      } noraise {
        value => value
      }
      let aux_iter = VerDefAuxIterator::new(
        self.endian,
        self.class,
        vd.vd_cnt,
        aux_offset,
        self.data,
      )
      // `vd_next` is an increment relative to the current VerDef record, not an
      // absolute offset from the start of the section.
      try checked_add(self.offset, uint_to_int_checked(vd.vd_next)) catch {
        _ => self.count = 0UL
      } noraise {
        new_offset => self.offset = new_offset
      }
      if self.count > 0UL {
        self.count -= 1UL
      }
      if self.count > 0UL && vd.vd_next == 0U {
        self.count = 0UL
      }
      Some((vd, aux_iter))
    }
  }
}

///|
/// Convert this iterator to `Iter[(VerDef, VerDefAuxIterator)]`.
pub fn VerDefIterator::iter(
  self : VerDefIterator,
) -> Iter[(VerDef, VerDefAuxIterator)] {
  Iter::new(fn() { self.next() })
}

///|
/// Auxiliary version-definition entry from `.gnu.version_d`.
///
/// Each entry names a version or dependency through the string table linked by
/// the section header.
pub(all) struct VerDefAux {
  /// Offset to the version/dependency name in the linked string table.
  vda_name : UInt
  /// Offset from this auxiliary entry to the next one, or zero to stop.
  vda_next : UInt
} derive(Debug, Eq)

///|
impl ParseAt for VerDefAux with parse_at(endian, _class, offset, data) {
  let end = checked_add(offset, VerDefAux::size_for(ELF32))
  let record = slice_checked(data, offset, end)
  let value = match endian {
    Little =>
      match record {
        [u32le(vda_name), u32le(vda_next)] => { vda_name, vda_next }
        _ => raise SliceReadError(offset, end)
      }
    Big =>
      match record {
        [u32be(vda_name), u32be(vda_next)] => { vda_name, vda_next }
        _ => raise SliceReadError(offset, end)
      }
  }
  (value, end)
}

///|
/// Size in bytes of one version-definition auxiliary record.
pub fn VerDefAux::size_for(_class : Class) -> Int {
  8
}

///|
/// Iterator over the auxiliary records for one `VerDef`.
pub struct VerDefAuxIterator {
  /// Byte order used to parse records.
  endian : Endian
  /// ELF class of the owning object.
  class : Class
  /// Remaining number of auxiliary records.
  mut count : UInt16
  /// Raw `.gnu.version_d` bytes.
  data : BytesView
  /// Current offset in `data`.
  mut offset : Int
}

///|
/// Create an iterator over `VerDefAux` records.
pub fn VerDefAuxIterator::new(
  endian : Endian,
  class : Class,
  count : UInt16,
  starting_offset : Int,
  data : BytesView,
) -> VerDefAuxIterator {
  { endian, class, count, data, offset: starting_offset }
}

///|
/// Parse the next version-definition auxiliary record.
pub fn VerDefAuxIterator::next(self : VerDefAuxIterator) -> VerDefAux? {
  if self.data.is_empty() || self.count == 0 {
    return None
  }
  try
    VerDefAux::parse_at(self.endian, self.class, self.offset, self.data)
  catch {
    _ => {
      self.count = 0
      None
    }
  } noraise {
    (vda, _) => {
      // `vda_next` advances relative to the current auxiliary record.
      try checked_add(self.offset, uint_to_int_checked(vda.vda_next)) catch {
        _ => self.count = 0
      } noraise {
        new_offset => self.offset = new_offset
      }
      if self.count > 0 {
        self.count -= 1
      }
      if self.count > 0 && vda.vda_next == 0U {
        self.count = 0
      }
      Some(vda)
    }
  }
}

///|
/// Convert this iterator to `Iter[VerDefAux]`.
pub fn VerDefAuxIterator::iter(self : VerDefAuxIterator) -> Iter[VerDefAux] {
  Iter::new(fn() { self.next() })
}

///|
/// Version requirement record from `.gnu.version_r`.
///
/// The section describes versioned symbols required from another shared object.
/// Auxiliary records reachable through `vn_aux` provide the individual version
/// names required from `vn_file`.
pub(all) struct VerNeed {
  /// Number of associated `VerNeedAux` records.
  vn_cnt : UInt16
  /// Offset to the required shared object file name in the linked string table.
  vn_file : UInt
  /// Offset from this record to the first `VerNeedAux`.
  vn_aux : UInt
  /// Offset from this record to the next `VerNeed`, or zero to stop.
  vn_next : UInt
} derive(Debug, Eq)

///|
impl ParseAt for VerNeed with parse_at(endian, _class, offset, data) {
  let end = checked_add(offset, VerNeed::size_for(ELF32))
  let record = slice_checked(data, offset, end)
  let (vn_version, value) = match endian {
    Little =>
      match record {
        [
          u16le(vn_version),
          u16le(vn_cnt),
          u32le(vn_file),
          u32le(vn_aux),
          u32le(vn_next),
        ] =>
          (
            vn_version.to_uint16(),
            { vn_cnt: vn_cnt.to_uint16(), vn_file, vn_aux, vn_next },
          )
        _ => raise SliceReadError(offset, end)
      }
    Big =>
      match record {
        [
          u16be(vn_version),
          u16be(vn_cnt),
          u32be(vn_file),
          u32be(vn_aux),
          u32be(vn_next),
        ] =>
          (
            vn_version.to_uint16(),
            { vn_cnt: vn_cnt.to_uint16(), vn_file, vn_aux, vn_next },
          )
        _ => raise SliceReadError(offset, end)
      }
  }
  if vn_version != VER_NEED_CURRENT {
    raise UnsupportedVersion(
      vn_version.to_uint64(),
      VER_NEED_CURRENT.to_uint64(),
    )
  }
  (value, end)
}

///|
/// Size in bytes of one version-requirement record.
pub fn VerNeed::size_for(_class : Class) -> Int {
  16
}

///|
/// Iterator over `VerNeed` records and their auxiliary-version iterators.
pub struct VerNeedIterator {
  /// Byte order used to parse records.
  endian : Endian
  /// ELF class of the owning object.
  class : Class
  /// Remaining number of requirement records.
  mut count : UInt64
  /// Raw `.gnu.version_r` bytes.
  data : BytesView
  /// Current offset in `data`.
  mut offset : Int
}

///|
/// Create a version-requirement iterator.
pub fn VerNeedIterator::new(
  endian : Endian,
  class : Class,
  count : UInt64,
  starting_offset : Int,
  data : BytesView,
) -> VerNeedIterator {
  { endian, class, count, data, offset: starting_offset }
}

///|
fn VerNeedIterator::copy(self : VerNeedIterator) -> VerNeedIterator {
  {
    endian: self.endian,
    class: self.class,
    count: self.count,
    data: self.data,
    offset: self.offset,
  }
}

///|
/// Parse the next `VerNeed` and create an iterator over its auxiliary records.
pub fn VerNeedIterator::next(
  self : VerNeedIterator,
) -> (VerNeed, VerNeedAuxIterator)? {
  if self.data.is_empty() || self.count == 0UL {
    return None
  }
  try VerNeed::parse_at(self.endian, self.class, self.offset, self.data) catch {
    _ => {
      self.count = 0UL
      None
    }
  } noraise {
    (vn, _) => {
      let aux_offset = try
        checked_add(self.offset, uint_to_int_checked(vn.vn_aux))
      catch {
        _ => {
          self.count = 0UL
          return None
        }
      } noraise {
        value => value
      }
      let aux_iter = VerNeedAuxIterator::new(
        self.endian,
        self.class,
        vn.vn_cnt,
        aux_offset,
        self.data,
      )
      // `vn_next` is an increment relative to the current VerNeed record.
      try checked_add(self.offset, uint_to_int_checked(vn.vn_next)) catch {
        _ => self.count = 0UL
      } noraise {
        new_offset => self.offset = new_offset
      }
      if self.count > 0UL {
        self.count -= 1UL
      }
      if self.count > 0UL && vn.vn_next == 0U {
        self.count = 0UL
      }
      Some((vn, aux_iter))
    }
  }
}

///|
/// Convert this iterator to `Iter[(VerNeed, VerNeedAuxIterator)]`.
pub fn VerNeedIterator::iter(
  self : VerNeedIterator,
) -> Iter[(VerNeed, VerNeedAuxIterator)] {
  Iter::new(fn() { self.next() })
}

///|
/// Auxiliary version requirement entry from `.gnu.version_r`.
pub(all) struct VerNeedAux {
  /// SysV ELF hash of the required version name.
  vna_hash : UInt
  /// Version requirement flags.
  vna_flags : UInt16
  /// Version index used in `.gnu.version`.
  vna_other : UInt16
  /// Offset to the required version name in the linked string table.
  vna_name : UInt
  /// Offset from this auxiliary entry to the next one, or zero to stop.
  vna_next : UInt
} derive(Debug, Eq)

///|
impl ParseAt for VerNeedAux with parse_at(endian, _class, offset, data) {
  let end = checked_add(offset, VerNeedAux::size_for(ELF32))
  let record = slice_checked(data, offset, end)
  let value = match endian {
    Little =>
      match record {
        [
          u32le(vna_hash),
          u16le(vna_flags),
          u16le(vna_other),
          u32le(vna_name),
          u32le(vna_next),
        ] =>
          {
            vna_hash,
            vna_flags: vna_flags.to_uint16(),
            vna_other: vna_other.to_uint16(),
            vna_name,
            vna_next,
          }
        _ => raise SliceReadError(offset, end)
      }
    Big =>
      match record {
        [
          u32be(vna_hash),
          u16be(vna_flags),
          u16be(vna_other),
          u32be(vna_name),
          u32be(vna_next),
        ] =>
          {
            vna_hash,
            vna_flags: vna_flags.to_uint16(),
            vna_other: vna_other.to_uint16(),
            vna_name,
            vna_next,
          }
        _ => raise SliceReadError(offset, end)
      }
  }
  (value, end)
}

///|
/// Size in bytes of one version-requirement auxiliary record.
pub fn VerNeedAux::size_for(_class : Class) -> Int {
  16
}

///|
/// Iterator over the auxiliary records for one `VerNeed`.
pub struct VerNeedAuxIterator {
  /// Byte order used to parse records.
  endian : Endian
  /// ELF class of the owning object.
  class : Class
  /// Remaining number of auxiliary records.
  mut count : UInt16
  /// Raw `.gnu.version_r` bytes.
  data : BytesView
  /// Current offset in `data`.
  mut offset : Int
}

///|
/// Create an iterator over `VerNeedAux` records.
pub fn VerNeedAuxIterator::new(
  endian : Endian,
  class : Class,
  count : UInt16,
  starting_offset : Int,
  data : BytesView,
) -> VerNeedAuxIterator {
  { endian, class, count, data, offset: starting_offset }
}

///|
/// Parse the next version-requirement auxiliary record.
pub fn VerNeedAuxIterator::next(self : VerNeedAuxIterator) -> VerNeedAux? {
  if self.data.is_empty() || self.count == 0 {
    return None
  }
  try
    VerNeedAux::parse_at(self.endian, self.class, self.offset, self.data)
  catch {
    _ => {
      self.count = 0
      None
    }
  } noraise {
    (vna, _) => {
      // `vna_next` advances relative to the current auxiliary record.
      try checked_add(self.offset, uint_to_int_checked(vna.vna_next)) catch {
        _ => self.count = 0
      } noraise {
        new_offset => self.offset = new_offset
      }
      if self.count > 0 {
        self.count -= 1
      }
      if self.count > 0 && vna.vna_next == 0U {
        self.count = 0
      }
      Some(vna)
    }
  }
}

///|
/// Convert this iterator to `Iter[VerNeedAux]`.
pub fn VerNeedAuxIterator::iter(self : VerNeedAuxIterator) -> Iter[VerNeedAux] {
  Iter::new(fn() { self.next() })
}
