///|
// Private lazy table for 32-bit hash-section words.
struct U32Table {
  table : ParsingTable[UInt]
}

///|
// Private lazy table for ELF64 GNU bloom-filter words.
priv struct U64Table {
  table : ParsingTable[UInt64]
}

///|
fn parse_uint_table_at(
  endian : Endian,
  _class : Class,
  offset : Int,
  data : BytesView,
) -> (UInt, Int) raise ParseError {
  let end = checked_add(offset, 4)
  let record = slice_checked(data, offset, end)
  let value = match endian {
    Little =>
      match record {
        [u32le(value)] => value
        _ => raise SliceReadError(offset, end)
      }
    Big =>
      match record {
        [u32be(value)] => value
        _ => raise SliceReadError(offset, end)
      }
  }
  (value, end)
}

///|
fn parse_uint64_table_at(
  endian : Endian,
  _class : Class,
  offset : Int,
  data : BytesView,
) -> (UInt64, Int) raise ParseError {
  let end = checked_add(offset, 8)
  let record = slice_checked(data, offset, end)
  let value = match endian {
    Little =>
      match record {
        [u64le(value)] => value
        _ => raise SliceReadError(offset, end)
      }
    Big =>
      match record {
        [u64be(value)] => value
        _ => raise SliceReadError(offset, end)
      }
  }
  (value, end)
}

///|
fn U32Table::U32Table(
  endian : Endian,
  class : Class,
  data : BytesView,
) -> U32Table {
  { table: ParsingTable(endian, class, data, 4, parse_uint_table_at) }
}

///|
fn U64Table::U64Table(
  endian : Endian,
  class : Class,
  data : BytesView,
) -> U64Table {
  { table: ParsingTable(endian, class, data, 8, parse_uint64_table_at) }
}

///|
fn U32Table::len(self : U32Table) -> Int {
  self.table.len()
}

///|
fn U32Table::is_empty(self : U32Table) -> Bool {
  self.table.is_empty()
}

///|
fn U32Table::get(self : U32Table, index : Int) -> UInt raise ParseError {
  self.table.get(index)
}

///|
fn U64Table::get(self : U64Table, index : Int) -> UInt64 raise ParseError {
  self.table.get(index)
}

///|
/// Header at the start of a SysV `.hash` section (`SHT_HASH`).
pub(all) struct SysVHashHeader {
  /// Number of bucket entries following the header.
  nbucket : UInt
  /// Number of chain entries following the bucket array.
  nchain : UInt
} derive(Debug, Eq)

///|
impl ParseAt for SysVHashHeader with parse_at(endian, _class, offset, data) {
  let end = checked_add(offset, 8)
  let record = slice_checked(data, offset, end)
  let header = match endian {
    Little =>
      match record {
        [u32le(nbucket), u32le(nchain)] => { nbucket, nchain }
        _ => raise SliceReadError(offset, end)
      }
    Big =>
      match record {
        [u32be(nbucket), u32be(nchain)] => { nbucket, nchain }
        _ => raise SliceReadError(offset, end)
      }
  }
  (header, end)
}

///|
/// Compute the SysV ELF hash value for a symbol name.
///
/// The input is the raw symbol name bytes without a trailing NUL. This helper is
/// useful when matching a manually chosen name against a `.hash` section.
pub fn sysv_hash(name : BytesView) -> UInt {
  let mut hash = 0U
  for byte in name {
    hash = hash * 16U + byte.to_uint()
    let high = hash & 0xf0000000U
    if high != 0U {
      hash = hash ^ (high >> 24)
    }
    hash = hash & high.lnot()
  }
  hash
}

///|
/// Parsed SysV `.hash` section.
///
/// The table stores bucket and chain arrays lazily and can resolve a symbol
/// name against a matching `SymbolTable` and `StringTable`.
pub struct SysVHashTable {
  /// Bucket array indexed by `sysv_hash(name) % nbucket`.
  buckets : U32Table
  /// Linked-list chain array storing the next symbol index for each symbol.
  chains : U32Table
}

///|
/// Parse a SysV hash table from raw `.hash` section bytes.
pub fn SysVHashTable::new(
  endian : Endian,
  class : Class,
  data : BytesView,
) -> SysVHashTable raise ParseError {
  let (hdr, offset0) = SysVHashHeader::parse_at(endian, class, 0, data)
  let mut offset = offset0
  let buckets_count = uint_to_int_checked(hdr.nbucket)
  let buckets_size = checked_mul(4, buckets_count)
  let buckets_end = checked_add(offset, buckets_size)
  let buckets_buf = slice_checked(data, offset, buckets_end)
  offset = buckets_end
  let chains_count = uint_to_int_checked(hdr.nchain)
  let chains_size = checked_mul(4, chains_count)
  let chains_end = checked_add(offset, chains_size)
  let chains_buf = slice_checked(data, offset, chains_end)
  {
    buckets: U32Table(endian, class, buckets_buf),
    chains: U32Table(endian, class, chains_buf),
  }
}

///|
/// Look up `name` in this SysV hash table.
///
/// Returns the matching symbol table index and parsed symbol if present. The
/// lookup is bounded by the chain table length to avoid infinite loops on
/// corrupted chain data.
pub fn SysVHashTable::find(
  self : SysVHashTable,
  name : BytesView,
  symtab : SymbolTable,
  strtab : StringTable,
) -> (Int, Symbol)? raise ParseError {
  if self.buckets.is_empty() {
    return None
  }
  let hash = sysv_hash(name)
  let start = uint_to_int_checked(
    hash % self.buckets.len().reinterpret_as_uint(),
  )
  let mut index = uint_to_int_checked(self.buckets.get(start))
  let mut i = 0
  // Follow the hash chain until symbol index zero or the chain length limit.
  while index != 0 && i < self.chains.len() {
    let symbol = symtab.get(index)
    if strtab.get_raw(uint_to_int_checked(symbol.st_name)) == name {
      return Some((index, symbol))
    }
    index = uint_to_int_checked(self.chains.get(index))
    i += 1
  }
  None
}

///|
/// Compute the GNU ELF hash value for a symbol name.
///
/// The input is the raw symbol name bytes without a trailing NUL.
pub fn gnu_hash(name : BytesView) -> UInt {
  let mut hash = 5381U
  for byte in name {
    hash = hash * 33U + byte.to_uint()
  }
  hash
}

///|
/// Header at the start of a GNU `.gnu.hash` section (`SHT_GNU_HASH`).
pub(all) struct GnuHashHeader {
  /// Number of bucket entries.
  nbucket : UInt
  /// First dynamic-symbol-table index represented by the chain array.
  table_start_idx : UInt
  /// Number of bloom-filter words.
  nbloom : UInt
  /// Shift count used for the second bloom-filter probe.
  nshift : UInt
} derive(Debug, Eq)

///|
impl ParseAt for GnuHashHeader with parse_at(endian, _class, offset, data) {
  let end = checked_add(offset, 16)
  let record = slice_checked(data, offset, end)
  let header = match endian {
    Little =>
      match record {
        [u32le(nbucket), u32le(table_start_idx), u32le(nbloom), u32le(nshift)] =>
          { nbucket, table_start_idx, nbloom, nshift }
        _ => raise SliceReadError(offset, end)
      }
    Big =>
      match record {
        [u32be(nbucket), u32be(table_start_idx), u32be(nbloom), u32be(nshift)] =>
          { nbucket, table_start_idx, nbloom, nshift }
        _ => raise SliceReadError(offset, end)
      }
  }
  (header, end)
}

///|
/// Parsed GNU `.gnu.hash` section.
///
/// GNU hash tables use a bloom filter followed by buckets and hash chains. The
/// chain array omits all symbols before `hdr.table_start_idx`.
pub struct GnuHashTable {
  /// Decoded GNU hash section header.
  hdr : GnuHashHeader
  /// Byte order for bloom, bucket, and chain words.
  endian : Endian
  /// ELF class, used to choose 32-bit or 64-bit bloom words.
  class : Class
  /// Raw bloom-filter byte range.
  bloom : BytesView
  /// Bucket array indexed by `gnu_hash(name) % nbucket`.
  buckets : U32Table
  /// Chain array of hash values, starting at `table_start_idx`.
  chains : U32Table
}

///|
/// Parse a GNU hash table from raw `.gnu.hash` section bytes.
pub fn GnuHashTable::new(
  endian : Endian,
  class : Class,
  data : BytesView,
) -> GnuHashTable raise ParseError {
  let (hdr, offset0) = GnuHashHeader::parse_at(endian, class, 0, data)
  let mut offset = offset0
  let nbloom = uint_to_int_checked(hdr.nbloom)
  let bloom_word_size = match class {
    ELF32 => 4
    ELF64 => 8
  }
  let bloom_size = checked_mul(nbloom, bloom_word_size)
  let bloom_end = checked_add(offset, bloom_size)
  let bloom = slice_checked(data, offset, bloom_end)
  offset = bloom_end
  let buckets_size = checked_mul(4, uint_to_int_checked(hdr.nbucket))
  let buckets_end = checked_add(offset, buckets_size)
  let buckets_buf = slice_checked(data, offset, buckets_end)
  offset = buckets_end
  let chains_buf = tail_checked(data, offset)
  {
    hdr,
    endian,
    class,
    bloom,
    buckets: U32Table(endian, class, buckets_buf),
    chains: U32Table(endian, class, chains_buf),
  }
}

///|
/// Look up `name` in this GNU hash table.
///
/// The bloom filter is tested first for quick negative answers. On a possible
/// hit, the bucket and chain arrays are scanned until the stop bit in the chain
/// hash is encountered.
pub fn GnuHashTable::find(
  self : GnuHashTable,
  name : BytesView,
  symtab : SymbolTable,
  strtab : StringTable,
) -> (Int, Symbol)? raise ParseError {
  if self.buckets.is_empty() || self.hdr.nbloom == 0U {
    return None
  }
  let hash = gnu_hash(name)
  // Test the class-sized bloom-filter word before touching buckets/chains.
  let (bloom_width, filter) = match self.class {
    ELF32 => {
      let width = 32
      let idx_u = hash / width.reinterpret_as_uint() % self.hdr.nbloom
      let table = U32Table(self.endian, self.class, self.bloom)
      (width, table.get(uint_to_int_checked(idx_u)).to_uint64())
    }
    ELF64 => {
      let width = 64
      let idx_u = hash / width.reinterpret_as_uint() % self.hdr.nbloom
      let table = U64Table(self.endian, self.class, self.bloom)
      (width, table.get(uint_to_int_checked(idx_u)))
    }
  }
  let width_u = bloom_width.reinterpret_as_uint()
  let bit1 = uint_to_int_checked(hash % width_u)
  if (filter & (1UL << bit1)) == 0UL {
    return None
  }
  let nshift = uint_to_int_checked(self.hdr.nshift)
  if nshift > 31 {
    raise IntegerOverflow
  }
  let hash2 = hash >> nshift
  let bit2 = uint_to_int_checked(hash2 % width_u)
  if (filter & (1UL << bit2)) == 0UL {
    return None
  }
  let table_start_idx = uint_to_int_checked(self.hdr.table_start_idx)
  let bucket_idx = uint_to_int_checked(
    hash % self.buckets.len().reinterpret_as_uint(),
  )
  let chain_start_idx = uint_to_int_checked(self.buckets.get(bucket_idx))
  if chain_start_idx < table_start_idx {
    return None
  }
  let chain_len = self.chains.len()
  for chain_idx in (chain_start_idx - table_start_idx)..<chain_len {
    let chain_hash = self.chains.get(chain_idx)
    // GNU chains ignore the low stop bit when comparing hash values.
    if (hash | 1U) == (chain_hash | 1U) {
      let sym_idx = checked_add(chain_idx, table_start_idx)
      let symbol = symtab.get(sym_idx)
      if strtab.get_raw(uint_to_int_checked(symbol.st_name)) == name {
        return Some((sym_idx, symbol))
      }
    }
    if (chain_hash & 1U) != 0U {
      break
    }
  }
  None
}
