pub type Expecter(a) {
  Expecter(provided_value: a)
}

pub fn expect(a) {
  Expecter(a)
}

pub fn to_be(expecter: Expecter(a), expected: a) -> Nil {
  case expecter.provided_value == expected {
    False -> panic
    True -> Nil
  }
}
