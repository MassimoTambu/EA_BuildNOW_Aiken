//// Basic lists map, all, any, filter, foldl, foldr

use aiken/collection/list
use aiken/collection/pairs

pub const simple_list: List<Int> = [1, 2, 3, 4, 5]

test testing_map() {
  list.map(simple_list, fn(x) { x + 1 }) == [2, 3, 4, 5, 6]
}

test testing_all() {
  list.all(simple_list, fn(x) { x > 0 }) == True
}

test testing_any() {
  list.any(simple_list, fn(x) { x > 3 }) == True
}

test testing_filter() {
  list.filter(simple_list, fn(x) { x > 3 }) == [4, 5]
}

test testing_foldr_acc() {
  list.foldl(simple_list, 0, fn(acc, x) { acc + x }) == 15
}

test testing_foldl_acc() {
  list.foldr(simple_list, 0, fn(x, acc) { acc + x }) == 15
}

test testing_foldr() {
  list.foldl(simple_list, [], fn(x, xs) { [x, ..xs] }) == [5, 4, 3, 2, 1]
}

test tesging_foldl() {
  list.foldr(simple_list, [], fn(x, xs) { [x, ..xs] }) == [1, 2, 3, 4, 5]
}

// ## Pairs (Tuples)

fn f() {
  let fixture: List<Pair<ByteArray, Int>> =
    [
      Pair("a", 100), Pair("b", 200), Pair("c", 300), Pair("d", 400),
      Pair("e", 500),
    ]

  fixture
}

test dfq() {
  pairs.map(f(), fn(_k, v) { v + 3 }) == [
    Pair("a", 103), Pair("b", 203), Pair("c", 303), Pair("d", 403),
    Pair("e", 503),
  ]
}
