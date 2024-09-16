// Aiken is functional language, 

fn main() {
  let x = 5
  let y = 6
  let z = x + y
  x + y + z
}

// Aiken compiler can infer the types of the arguments and the return type
fn sum(x, y) {
  x + y
}

fn sum_explicit(x: Int, y: Int) -> Int {
  x + y
}

fn sub(x: Int, y: Int) -> Int {
  x - y
}

fn mul(x: Int, y: Int) -> Int {
  x * y
}

fn div(x: Int, y: Int) -> Int {
  x / y
}

test sub_test() {
  sub(5, 3) == 2
}

test mul_test() {
  mul(5, 3) == 15
}

test sub_mul_test() {
  mul(sub(5, 3), 2) == 4
}

test div_test() {
  div(6, 3) == 2
}

// Lets check that our functions work by testing them
test main_test() {
  main() == 22
}

test sum_test() {
  sum(5, 6) == 11
}

test sum_explicit_test() {
  sum_explicit(5, 6) == 11
}
