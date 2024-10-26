use aiken/interval
use cardano/address
use cardano/assets
use cardano/transaction.{Input, NoDatum, Output, OutputReference, Transaction}

pub fn dummy_transaction() -> Transaction {
  let utxo_ref =
    OutputReference(
      #"0000000000000000000000000000000000000000000000000000000000000000",
      0,
    )

  let token_value = assets.from_asset("41D0", #"6e6f5f6e616d655f746f6b656e", 1)
  let tx_value = assets.from_lovelace(11_000_000) |> assets.merge(token_value)

  // Address { VerificationKeyCredential { "AD812" }, None }:
  let dummy_addr =
    address.from_verification_key(
      #"2070f8488dd696b78a5f23e38d273550e43660526c4b19cba733b488",
    )

  let output =
    Output {
      address: dummy_addr,
      value: tx_value,
      datum: NoDatum,
      reference_script: None,
    }
  let input =
    Input {
      output_reference: utxo_ref,
      output: Output {
        address: dummy_addr,
        value: assets.from_lovelace(50_000_000),
        datum: NoDatum,
        reference_script: None,
      },
    }

  let tx =
    Transaction {
      ..transaction.placeholder,
      inputs: [input],
      outputs: [output],
      fee: 2_000_000,
      mint: token_value,
      validity_range: interval.before(1000000000),
      id: "AD812",
    }

  tx
}
