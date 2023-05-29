import galvanize/should
import galvanize/assertion.{Assertion}
import gleeunit/should as glee_should

pub fn should_equal_test() {
  1
  |> should.be_equal(1)
  |> should_pass

  [1, 2, 3]
  |> should.be_equal([1, 2, 3])
  |> should_pass

  1
  |> should.be_equal(2)
  |> should_fail

  [1, 2, 3]
  |> should.be_equal([3, 2, 1])
  |> should_fail
}

fn should_fail(assertion: Assertion) {
  assertion
  |> assertion.to_result
  |> glee_should.be_error
}

fn should_pass(assertion: Assertion) {
  assertion
  |> assertion.to_result
  |> glee_should.be_ok
}

pub fn should_differ_test() {
  1
  |> should.differ(from: 2)
  |> should_pass

  1
  |> should.differ(from: 1)
  |> should_fail

  [1, 2, 3]
  |> should.differ(from: [3, 2, 1])
  |> should_pass

  [1, 2, 3]
  |> should.differ(from: [1, 2, 3])
  |> should_fail
}

pub fn should_be_ok_test() {
  Ok(1)
  |> should.be_ok
  |> should_pass

  Error(1)
  |> should.be_ok
  |> should_fail
}

pub fn should_be_error_test() {
  Error(1)
  |> should.be_error
  |> should_pass

  Ok(1)
  |> should.be_error
  |> should_fail
}

pub fn should_be_lower_test() {
  1
  |> should.be_lower(than: 0)
  |> should_fail

  1
  |> should.be_lower(than: 1)
  |> should_fail

  1
  |> should.be_lower(than: 2)
  |> should_pass
}

pub fn should_be_lower_or_equal_test() {
  1
  |> should.be_lower_or_equal(to: 0)
  |> should_fail

  1
  |> should.be_lower_or_equal(to: 1)
  |> should_pass

  1
  |> should.be_lower_or_equal(to: 2)
  |> should_pass
}

pub fn should_be_greater_test() {
  1
  |> should.be_greater(than: 0)
  |> should_pass

  1
  |> should.be_greater(than: 1)
  |> should_fail

  1
  |> should.be_greater(than: 2)
  |> should_fail
}

pub fn should_be_greater_or_equal_test() {
  1
  |> should.be_greater_or_equal(to: 0)
  |> should_pass

  1
  |> should.be_greater_or_equal(to: 1)
  |> should_pass

  1
  |> should.be_greater_or_equal(to: 2)
  |> should_fail
}
