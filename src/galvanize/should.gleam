import gleam/list

pub fn equal(input: a, expected: a) -> Nil {
  case input == expected {
    True -> Nil
    False -> panic
  }
}

pub fn not_equal(input: a, expected: a) -> Nil {
  case input == expected {
    True -> panic
    False -> Nil
  }
}

pub fn be_in(input: a, expected: List(a)) -> Nil {
  case list.contains(expected, input) {
    True -> Nil
    False -> panic
  }
}
