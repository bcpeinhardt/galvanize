/// Describes the result of a single test's comparison.
///
pub opaque type Assertion {
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

/// Turns an assertion into a `Result`.
///
pub fn to_result(assertion: Assertion) -> Result(Nil, Reason) {
  case assertion {
    Pass -> Ok(Nil)
    Fail(reason) -> Error(reason)
  }
}

/// An assertion that never fails.
///
pub fn pass() -> Assertion {
  Pass
}

/// A shorthand equivalent to `fail_with_reason(GenericFailure(reason))`.
///
pub fn fail(with reason: String) -> Assertion {
  Fail(GenericFailure(reason))
}

/// Create an assertion that always fails with the given reason.
///
pub fn fail_with_reason(with reason: Reason) -> Assertion {
  Fail(reason)
}
