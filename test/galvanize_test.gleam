import galvanize.{add, run_seq, test, test_suite}
import galvanize/should

pub fn main() {
  test_suite("Arithmetic")
  |> add({
    use <- test("One plus One")
    1 + 1
    |> should.equal(2)
  })
  |> add({
    use <- test("Two minus one")
    2 - 1
    |> should.equal(1)
  })
  |> add({
    use <- test("Should panic")
    panic
  })
  |> run_seq
}
