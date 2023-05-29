/// Describes the result of a single test's comparison.
///
pub type Assertion {
  Pass
  Fail(Reason)
}

/// The reason why an assertion failed.
///
pub type Reason {
  EqualityAssertionFailed(expected: String, actual: String)
  AssertionFailed(subject: String, asserted: String, object: String)
  GenericFailure(reason: String)
}

pub fn reason_to_string(reason: Reason) -> String {
  case reason {
    EqualityAssertionFailed(expected, actual) ->
      "Expected: " <> expected <> ", Found: " <> actual
    AssertionFailed(subject, asserted, object) ->
      subject <> " " <> asserted <> " " <> object
    GenericFailure(reason) -> reason
  }
}

/// Turns an assertion into a `Result`.
///
pub fn to_result(assertion: Assertion) -> Result(Nil, Reason) {
  case assertion {
    Pass -> Ok(Nil)
    Fail(reason) -> Error(reason)
  }
}

/// Returns `True` if the assertion has failed.
///
/// ## Examples
///
/// ```gleam
/// > 1 |> should.be_equal(to: 1) |> has_failed
/// False
/// ```
///
/// ```gleam
/// > 1 |> should.differ(from: 1) |> has_failed
/// True
/// ```
///
pub fn has_failed(assertion: Assertion) -> Bool {
  case assertion {
    Pass -> False
    Fail(_) -> True
  }
}

/// An assertion that never fails.
///
/// ## Examples
///
/// ```gleam
/// > pass() |> has_failed
/// False
/// ```
///
pub fn pass() -> Assertion {
  Pass
}

/// A shorthand equivalent to `fail_with_reason(GenericFailure(reason))`.
///
/// ## Examples
///
/// ```gleam
/// > fail(with: "always fails") |> to_result
/// Error(GenericFailure("always fails"))
/// ```
///
pub fn fail(with reason: String) -> Assertion {
  Fail(GenericFailure(reason))
}

/// Create an assertion that always fails with the given reason.
/// It is recommended to only use this function if the preexisting
/// assertions in the `galvanize/should` module do not fit your needs.
///
/// ## Examples
///
/// ```gleam
/// > fail_with_reason(EqualityAssertionFailed("1", "2")) |> to_result
/// Error(EqualityAssertionFailed("1", "2"))
/// ```
///
pub fn fail_with_reason(with reason: Reason) -> Assertion {
  Fail(reason)
}
