import gleam/io
import gleam/int
import gleam/iterator
import colours
import galvanize/test.{Test}

pub type TestSuite {
  TestSuite(name: String, tests: List(Test))
}

pub fn test_suite(name: String) -> TestSuite {
  TestSuite(name, [])
}

pub fn add_test(test_suite: TestSuite, test: Test) -> TestSuite {
  TestSuite(..test_suite, tests: [test, ..test_suite.tests])
}

pub fn run(test_suite: TestSuite) {
  colours.fgdarkgreen("Running Test Suite: " <> test_suite.name)
  |> io.println

  let test_iter =
    test_suite.tests
    |> iterator.from_list
    |> iterator.index

  use #(i, Test(name, inner)) <- iterator.each(test_iter)
  inner()
  print_successful(i, name)
}

fn print_successful(n: Int, name: String) {
  int.to_string(n + 1) <> ". " <> name
  |> colours.fgdarkgreen
  |> io.println
}
