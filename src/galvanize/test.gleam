pub type Test {
  Test(name: String, inner: fn() -> Nil)
}

pub fn name(test_name: String, func: fn() -> Nil) -> Test {
  Test(test_name, func)
}
