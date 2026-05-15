///|
// Maximum `UInt64` value that can be represented by MoonBit `Int` in this
// package's offset math.
let max_int_u64 : UInt64 = 0x7fffffffUL

///|
// Maximum `UInt` value that can be reinterpreted safely as a non-negative `Int`.
let max_int_uint : UInt = 0x7fffffffU

///|
// Keep the limit explicit so checked math does not depend on backend details.
let max_int_value : Int = 0x7fffffff

///|
// Checked byte-offset addition used before every slice boundary calculation.
fn checked_add(a : Int, b : Int) -> Int raise ParseError {
  if a < 0 || b < 0 || a > max_int_value - b {
    raise IntegerOverflow
  }
  a + b
}

///|
// Checked byte-size multiplication used for table-length calculations.
fn checked_mul(a : Int, b : Int) -> Int raise ParseError {
  if a < 0 || b < 0 {
    raise IntegerOverflow
  }
  if b != 0 && a > max_int_value / b {
    raise IntegerOverflow
  }
  a * b
}

///|
// Convert a parsed ELF64 offset or size into a MoonBit slice index.
fn u64_to_int_checked(value : UInt64) -> Int raise ParseError {
  if value > max_int_u64 {
    raise IntegerOverflow
  }
  value.to_int()
}

///|
// Convert a parsed ELF32 count or index into a MoonBit slice index.
fn uint_to_int_checked(value : UInt) -> Int raise ParseError {
  if value > max_int_uint {
    raise IntegerOverflow
  }
  value.reinterpret_as_int()
}

///|
// Bounds-checked slicing wrapper that normalizes failures to ParseError.
fn slice_checked(
  data : BytesView,
  start : Int,
  end : Int,
) -> BytesView raise ParseError {
  if start < 0 || end < start || end > data.length() {
    raise SliceReadError(start, end)
  }
  data[start:end]
}

///|
// Return `data[start:]` after checking the start offset.
fn tail_checked(data : BytesView, start : Int) -> BytesView raise ParseError {
  if start < 0 || start > data.length() {
    raise SliceReadError(start, data.length())
  }
  data[start:]
}

///|
/// Trait implemented by structures that can parse themselves from ELF bytes.
///
/// Implementations receive the file byte order, ELF class, byte offset, and the
/// source byte slice. They return the parsed value and the next offset. This is
/// the small abstraction used by every lazy table wrapper in the package.
pub(open) trait ParseAt {
  /// Parse one value at `offset` from `BytesView`, using the supplied class and endian.
  parse_at(Endian, Class, Int, BytesView) -> (Self, Int) raise ParseError
}

///|
// Ensure that an on-disk table entry size matches the parser's expected size.
fn validate_entsize(entsize : Int, expected : Int) -> Int raise ParseError {
  if entsize != expected {
    raise BadEntsize(entsize.to_uint64(), expected.to_uint64())
  }
  entsize
}

///|
/// Lazy parsing table over a contiguous sequence of fixed-size ELF records.
///
/// A `ParsingTable` keeps only the source bytes, layout information, and parser
/// callback. Individual entries are decoded when `get` or `iter` requests them,
/// which avoids eagerly materializing large section, segment, or symbol tables.
pub struct ParsingTable[T] {
  /// Byte order of the file that owns the table.
  endian : Endian
  /// ELF32 or ELF64 record layout.
  class : Class
  /// Raw byte range containing the table.
  data : BytesView
  /// Size in bytes of one table entry.
  entry_size : Int
  /// Parser function for one entry.
  parser : (Endian, Class, Int, BytesView) -> (T, Int) raise ParseError
  /// Type witness used only to retain the generic parameter.
  phantom : T?
}

///|
fn[T] ParsingTable::ParsingTable(
  endian : Endian,
  class : Class,
  data : BytesView,
  entry_size : Int,
  parser : (Endian, Class, Int, BytesView) -> (T, Int) raise ParseError,
) -> ParsingTable[T] {
  { endian, class, data, entry_size, parser, phantom: None }
}

///|
/// Number of entries in the table.
///
/// A non-positive entry size is treated as an empty table to avoid division by
/// zero on malformed internal construction.
pub fn[T] ParsingTable::len(self : ParsingTable[T]) -> Int {
  if self.entry_size <= 0 {
    0
  } else {
    self.data.length() / self.entry_size
  }
}

///|
/// Returns `true` when `len` is zero.
pub fn[T] ParsingTable::is_empty(self : ParsingTable[T]) -> Bool {
  self.len() == 0
}

///|
/// Parse and return the entry at `index`.
///
/// Raises `BadOffset` for negative or out-of-range indices, and propagates any
/// parse error produced by the entry parser.
pub fn[T] ParsingTable::get(
  self : ParsingTable[T],
  index : Int,
) -> T raise ParseError {
  if index < 0 {
    raise BadOffset(0UL)
  }
  if self.data.is_empty() {
    raise BadOffset(index.to_uint64())
  }
  let start = checked_mul(index, self.entry_size)
  if start >= self.data.length() {
    raise BadOffset(index.to_uint64())
  }
  let (value, _) = (self.parser)(self.endian, self.class, start, self.data)
  value
}

///|
/// Iterate over the table, parsing entries on demand.
///
/// If a parse error is encountered, iteration stops. Use `get` when the caller
/// needs the exact parse error for a specific entry.
pub fn[T] ParsingTable::iter(self : ParsingTable[T]) -> Iter[T] {
  let idx = Ref(0)
  let failed = Ref(false)
  Iter::new(
    fn() {
      if failed.val || idx.val >= self.len() {
        None
      } else {
        let i = idx.val
        idx.val += 1
        try self.get(i) catch {
          _ => {
            failed.val = true
            None
          }
        } noraise {
          value => Some(value)
        }
      }
    },
    size_hint=self.len(),
  )
}
