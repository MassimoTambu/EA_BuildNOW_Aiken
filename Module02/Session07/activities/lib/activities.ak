use aiken/crypto.{VerificationKeyHash}
use aiken/interval.{
  Finite, Interval, after, before, entirely_between, hull, intersection,
  is_entirely_after, is_entirely_before,
}
use cardano/transaction.{ValidityRange}

pub type CFdatum {
  Campaign {
    title: ByteArray,
    goal: Int,
    creator: VerificationKeyHash,
    deadline: Int,
    current_funds: Int,
  }
  Backer { backer: VerificationKeyHash }
}

/// 0 -> Cancel
/// 1 -> Update
/// 2 -> Close
pub type Action =
  Int

/// 1. Fix me!
fn check_backer_datum(datum: CFdatum) -> VerificationKeyHash {
  when datum is {
    Campaign { creator, .. } -> creator
    Backer { backer } -> backer
  }
}

/// 2. Make it work!
fn check_redeemer_action(redeemer: Action) -> Bool {
  // [mem: 14720, cpu: 3599384] test_02
  if redeemer >= 0 && redeemer <= 2 {
    True
  } else {
    False
  }
  // PASS [mem: 15922, cpu: 3987734] test_02 with "when is"
  // when redeemer is {
  //   0 -> True
  //   1 -> True
  //   2 -> True
  //   _ -> False
  // }
}

/// 3.
fn in_the_window_of_time(
  window_interval: Interval<Int>,
  tx_interval: Interval<Int>,
) -> Bool {
  hull(window_interval, tx_interval) == window_interval
}

///Test start here
test test_01() {
  check_backer_datum(Backer { backer: "ACDF" }) == "ACDF"
}

test test_02() {
  and {
    check_redeemer_action(0),
    check_redeemer_action(1),
    check_redeemer_action(2),
    !check_redeemer_action(333),
  }
}

test test_a03() {
  let window = entirely_between(1731171600000, 1731173400000)
  in_the_window_of_time(window, between(1731172200000, 1731172800000)) && !in_the_window_of_time(
    window,
    between(1731171400000, 1731171800000),
  )
}
