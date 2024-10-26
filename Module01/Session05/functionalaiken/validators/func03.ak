//// Recursion

fn factorial(x: Int) -> Int {
  when x is {
    0 -> 1
    1 -> 1
    _ -> x * factorial(x - 1)
  }
}

fn factorial_if(x: Int) -> Int {
  if x == 0 {
    1
  } else if x == 1 {
    1
  } else {
    x * factorial(x - 1)
  }
}

test test_factorial() {
  factorial(5) == 120
}

test test_factorial_if() {
  factorial_if(5) == 120
}
