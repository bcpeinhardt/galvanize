import gleam/otp/task.{Exit, Timeout}
import gleam/io
import gleam/list
import colours

/// A test is just a name and a function that takes no parameters and returns Nil
/// The test passes if the function executes without panicking
/// The test fails if the function panics
pub type Test =
  #(String, fn() -> Nil)

/// A test suite has a name and a list of tests
pub type TestSuite =
  #(String, List(Test))

/// A test can either pass or fail. If it failed, there 
/// should be a reason
pub type TestOutcome {
  Passed
  Failed(reason: String)
}

/// Convenience function for creating a test with use syntax
pub fn test(name: String, test_func: fn() -> Nil) -> Test {
  #(name, test_func)
}

/// Run a test by sending it to execute in a separate task
pub fn run_test(test: Test) {
  let #(name, func) = test
  case
    task.async(func)
    |> task.try_await(60)
  {
    Ok(_) ->
      name <> " passed"
      |> colours.fgdarkgreen
      |> io.println
    Error(Timeout) ->
      name <> " timed out"
      |> colours.fgdarkred1
      |> io.println
    Error(Exit(_)) ->
      name <> " failed"
      |> colours.fgdarkred1
      |> io.println
  }
}

/// Run a list of tests sequentially
pub fn run_seq(test_suite: TestSuite) {
  let #(name, tests) = test_suite
  "Running Test Suite: " <> name
  |> colours.fgdarkgreen
  |> io.println
  {
    use tst <- list.each(tests)
    run_test(tst)
  }
}

pub fn test_suite(name: String) -> TestSuite {
  #(name, [])
}

pub fn add(test_suite: TestSuite, tst: Test) -> TestSuite {
  let #(name, tests) = test_suite
  #(name, [tst, ..tests])
}
