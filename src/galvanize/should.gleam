//// Assertions are the basic building blocks of tests: any test
//// suite is comprised of one or more assertions that can be grouped
//// together:
////
//// ```gleam
//// TODO: add example of a couple assertions in a test
////       once we decide on an interface
//// ```
////
//// This module exposes some basic functions used to make assertions
//// and combine them.
//// 

import galvanize/assertion.{Assertion}
import gleam/string
import gleam/int

/// An assertion that passes if the arguments are equal.
///
/// ## Examples
///
/// ```gleam
/// import gleam.list
///
/// ["a", "b", "c"]
/// |> list.length
/// |> equal(3)
/// // This assertion passes.
/// ```
///
/// ```gleam
/// Ok(1)
/// |> equal(Error("a"))
/// // This assertion fails.
/// ```
///
pub fn equal(actual: a, expected: a) -> Assertion {
  // TODO: for now in case of equality failure the only reason is `Equality`
  // At the end it will just show the two strings side by side (maybe even
  // with sime kind of super simple diff).
  // However, it could be nice to show more useful diffs for some special
  // types like sets and maps to just highlight the diffing elements.
  //
  // This could be achieved in two ways that I can think of:
  // - making other specialized functions `equal_set`, `equal_map`, ...
  //   that can handle the diffing and report different failure reasons
  //   with more detail for the test runner to show
  // - keeping a single `should.equal` (maybe better in terms of DX)
  //   and use an ugly hack inside: turn the compared data into a dynamic,
  //   inspect its type with `inspect` and use the appropriate reason based
  //   on that defaulting to the `Equality` reason for anything that does
  //   not require nothing more than a simple diff.
  case actual == expected {
    True -> assertion.pass()
    False ->
      assertion.fail_with_reason(assertion.EqualityAssertionFailed(
        actual: string.inspect(actual),
        expected: string.inspect(expected),
      ))
  }
}

/// An assertion that passes if the arguments are not equal.
///
/// ## Examples
///
/// ```gleam
/// import gleam.list
///
/// ["a", "b", "c"]
/// |> list.length
/// |> not_equal(2)
/// // This assertion passes.
/// ```
///
/// ```gleam
/// Ok(1)
/// |> not_equal(Ok(1))
/// // This assertion fails.
/// ```
///
pub fn not_equal(one: a, other: a) -> Assertion {
  case one != other {
    True -> assertion.pass()
    False ->
      assertion.fail_with_reason(assertion.AssertionFailed(
        string.inspect(one),
        "should not equal",
        string.inspect(other),
      ))
  }
}

/// An assertion that passes if its argument is `Ok(_)`.
///
/// ## Examples
///
/// ```gleam
/// Ok(1) |> be_ok
/// // This assertion passes.
/// ```
///
/// ```gleam
/// Error("a") |> be_ok
/// // This assertion fails.
/// ```
///
pub fn be_ok(value: Result(a, e)) -> Assertion {
  case value {
    Ok(_) -> assertion.pass()
    Error(_) ->
      assertion.fail_with_reason(assertion.AssertionFailed(
        string.inspect(value),
        "should be",
        "Ok(_)",
      ))
  }
}

/// An assertion that passes if its argument is `Error(_)`.
///
/// ## Examples
///
/// ```gleam
/// Error(1) |> be_error
/// // This assertion passes.
/// ```
///
/// ```gleam
/// Ok("a") |> be_error
/// // This assertion fails.
/// ```
///
pub fn be_error(value: Result(a, e)) -> Assertion {
  case value {
    Error(_) -> assertion.pass()
    Ok(_) ->
      assertion.fail_with_reason(assertion.AssertionFailed(
        string.inspect(value),
        "should be",
        "Error(_)",
      ))
  }
}

/// An assertion that passes if the first argument is striclty lower
/// than the other.
///
/// ## Examples
///
/// ```gleam
/// > 2 |> be_lower(than: 4)
/// // This assertion passes.
/// ```
///
/// ```gleam
/// > 2 |> be_lower(than: 2)
/// > 2 |> be_lower(than: 1)
/// // These assertions fail.
/// ```
///
pub fn be_lower(value: Int, than other: Int) -> Assertion {
  "should be lower than"
  |> compare(value, other, fn(n, m) { n < m }, int.to_string)
}

/// An assertion that passes if the first argument is lower or equal
/// to the other.
///
/// ## Examples
///
/// ```gleam
/// > 2 |> be_lower_or_equal(to: 4)
/// > 2 |> be_lower_or_equal(to: 2)
/// // These assertions pass.
/// ```
///
/// ```gleam
/// > 2 |> be_lower_or_equal(to: 1)
/// // This assertion fails.
/// ```
///
pub fn be_lower_or_equal(value: Int, to other: Int) -> Assertion {
  "should be lower or equal to"
  |> compare(value, other, fn(n, m) { n <= m }, int.to_string)
}

/// An assertion that passes if the first argument is striclty greater
/// than the other.
///
/// ## Examples
///
/// ```gleam
/// > 3 |> be_greater(than: 2)
/// // This assertion passes.
/// ```
///
/// ```gleam
/// > 3 |> be_greater(than: 3)
/// > 3 |> be_greater(than: 4)
/// // These assertions fail.
/// ```
///
pub fn be_greater(value: Int, than other: Int) -> Assertion {
  "should be greater than"
  |> compare(value, other, fn(n, m) { n > m }, int.to_string)
}

/// An assertion that passes if the first argument is greater
/// or equal to the other.
///
/// ## Examples
///
/// ```gleam
/// > 3 |> be_greater_or_equal(to: 2)
/// > 3 |> be_greater_or_equal(to: 3)
/// // These assertions pass.
/// ```
///
/// ```gleam
/// > 3 |> be_greater_or_equal(to: 4)
/// // This assertion fails.
/// ```
///
pub fn be_greater_or_equal(value: Int, to other: Int) -> Assertion {
  "should be greater or equal to"
  |> compare(value, other, fn(n, m) { n >= m }, int.to_string)
}

/// TODO: add a group of assertions to work on floating point numbers!
fn compare(
  asserted: String,
  value: a,
  other: a,
  comparison: fn(a, a) -> Bool,
  to_string: fn(a) -> String,
) -> Assertion {
  case comparison(value, other) {
    True -> assertion.pass()
    False ->
      assertion.fail_with_reason(assertion.AssertionFailed(
        to_string(value),
        asserted,
        to_string(other),
      ))
  }
}