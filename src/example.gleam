//// This module is just for demonstrating an example test suite written with galvanize.
//// You can run it by running `gleam run -m example`

import galvanize/should
import galvanize.{add, run_seq, test, test_suite}

pub fn main() {
  test_suite("Arithmetic")
  |> add(test(
    "One plus one",
    fn() {
      1 + 1
      |> should.be_equal(to: 2)
    },
  ))
  |> add(test(
    "Two minus one should be one",
    fn() {
      2 - 1
      |> should.be_equal(to: 1)
    },
  ))
  |> add(test(
    "Two and two are different",
    fn() {
      2
      |> should.differ(from: 2)
    },
  ))
  |> run_seq
}
