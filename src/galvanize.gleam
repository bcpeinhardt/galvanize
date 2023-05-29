import gleam/otp/task.{Exit, Timeout}
import gleam/io
import gleam/list
import colours
import galvanize/assertion.{Assertion, Fail, Pass, reason_to_string}

const passing_colour = colours.fgpalegreen4

const failing_colour = colours.fgred3

type Test =
  #(String, fn() -> Assertion)

type TestSuite =
  #(String, List(Test))

/// Function for creating a test.
/// 
/// ## Example
/// ```gleam
/// use <- test("One plus one equals two")
/// 1 + 1 |> should.be_equal(to: 2)
/// ```
pub fn test(name: String, test_func: fn() -> Assertion) -> Test {
  #(name, test_func)
}

fn run_test(test: Test) {
  let #(name, func) = test
  case
    task.async(func)
    |> task.try_await(60)
  {
    Ok(ass) -> {
      case ass {
        Pass -> {
          "Test: " <> name <> " passed"
          |> passing_colour
          |> colours.italic
          |> io.println
        }
        Fail(reason) -> {
          "Test: " <> name <> " failed: " <> reason_to_string(reason)
          |> failing_colour
          |> colours.italic
          |> io.println
        }
      }
    }
    Error(Timeout) ->
      "Test: " <> name <> " timed out!"
      |> failing_colour
      |> colours.italic
      |> io.println
    Error(Exit(_)) ->
      "Test: " <> name <> " failed!"
      |> failing_colour
      |> colours.italic
      |> io.println
  }
}

/// Run a test suite sequentially.
pub fn run_seq(test_suite: TestSuite) {
  let #(name, tests) = test_suite
  "Running Test Suite: " <> name
  |> passing_colour
  |> io.println
  {
    use tst <- list.each(tests)
    run_test(tst)
  }
}

/// Create a new test suite
pub fn test_suite(name: String) -> TestSuite {
  #(name, [])
}

/// Add a test to the test suite
pub fn add(test_suite: TestSuite, tst: Test) -> TestSuite {
  let #(name, tests) = test_suite
  #(name, [tst, ..tests])
}
