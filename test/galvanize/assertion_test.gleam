import galvanize/assertion
import gleeunit/should

pub fn pass_test() {
  assertion.pass()
  |> assertion.has_failed
  |> should.equal(False)

  assertion.pass()
  |> assertion.to_result
  |> should.be_ok
}

pub fn fail_test() {
  let assertion = assertion.fail("reason")

  assertion
  |> assertion.has_failed
  |> should.equal(True)

  assertion
  |> assertion.to_result
  |> should.equal(Error(assertion.GenericFailure("reason")))
}

pub fn fail_with_reason_test() {
  let reason = assertion.GenericFailure("fail")
  let assertion = assertion.fail_with_reason(reason)

  assertion
  |> assertion.has_failed
  |> should.equal(True)

  assertion
  |> assertion.to_result
  |> should.equal(Error(reason))

  assertion
  |> should.equal(assertion.fail("fail"))
}
