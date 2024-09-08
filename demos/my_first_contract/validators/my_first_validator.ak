validator my_func {
  spend(
    _datum: Option<Data>,
    _redeemer: Data,
    _output_reference: Data,
    _context: Data,
  ) {
    True
  }

  else(_) {
    fail
  }
}

test my_test() {
  my_func.spend(None, 0, 0, 0) == True
}
