import galvanize/test_suite.{add_test, run, test_suite}
import galvanize/test.{name}
import galvanize/expecter.{expect, to_be}

pub fn main() {
  // You have to register tests yourself :/
  test_suite("Arithmetic")
  |> add_test(addition(1))
  |> run()
  // But you get to specify execution order
}

/// Write tests as functions.
/// Context can be passed as parameters
pub fn addition(one: Int) {
  use <- name("One Plus One")
  expect(one + 1)
  |> to_be(2)
}
