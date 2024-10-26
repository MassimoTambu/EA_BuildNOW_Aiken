//// In Cardano we get no floating point numbers, so we have to use integers.
//// 
//// Then how do we manage simple financial calculations, like interest rates?
//// We can use integers and divide by 100 to get the percentage.
//// But what if we want to calculate the interest of a loan of 100 ADA at 20%?
//// We can use fixed point arithmetic.

type FixedP =
  Pair<Int, Int>

fn fixed_point_division(valor_i: Int, interes_i: Int, precision: Int) -> FixedP {
  let valor_fix = valor_i * precision_multiplier(precision)
  let interes_fix = interes_i * precision_multiplier(precision)

  Pair(
    valor_fix / interes_fix,
    valor_i % interes_i * precision_multiplier(precision) / interes_i,
  )
}

fn precision_multiplier(precision: Int) -> Int {
  when precision is {
    0 -> 1
    1 -> 10
    2 -> 100
    3 -> 1000
    4 -> 10000
    5 -> 100000
    6 -> 1000000
    _ -> fail
  }
}

// ## FP presentation must be done off-chain

test fixed_point_example_test() {
  let fp = fixed_point_division(100, 2000, 6)
  let Pair(n, d) = fp

  n * 1000000 + d == 50000
}
