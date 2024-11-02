use cardano/transaction.{
  DatumHash, InlineDatum, Input, NoDatum, Output, OutputReference, Transaction,
  find_input,
}

// This Smart Contract task gives the user the ability to delegate and undelegate
// their voting power to multiple DReps at the same time.
//
// Tasks:
// 0. Understand if it is possible to use the staking keys as a way to delegate to multiple DReps.
// 1. Understand how to be sure that the user gives in the redeemer the DReps' addresses and not just random addresses.
// 2. Implement the delegate function
// 3. Implement the undelegate function
// 4. Add Collateral
// 5. Implement the delegate function but for multiple DReps
// 6. Implement the undelegate function but for multiple DReps
// 7. Implement the update_delegation function if needed, but see first if it is possible to use delegate function again

// The Pair define the Address and the amount of ADA to be delegated
// If the amount of ADA is 0, then the user is undelegating
// Check how this can work with update_delegation function
type RedeemerAction =
  Pair<Address, Int>

validator multi_delegation {
  publish(redeemer: RedeemerAction, certificate: Certificate, self: Transaction) {
    expect redeemer.2nd >= 0 && redeemer.2nd <= 100
    when redeemer.2nd is {
      0 -> undelegate(certificate, self)
      >= 1 -> undelegate(certificate, self)
      _ -> fail @"Invalid action"
    }
  }

  else(_) {
    fail
  }
}

fn delegate(certificate: Certificate, tx: Transaction) {
  let input = find_input(tx.inputs, certificate.staking_reference)
  let output = tx.outputs
  [input.index]
  let output_address = output.address
}

fn find_input_address(utxo_ref: OutputReference, inputs: List<Input>) -> Address {
  expect Some(input_utxo) = find_input(inputs, utxo_ref)
  input_utxo.output.address
}
