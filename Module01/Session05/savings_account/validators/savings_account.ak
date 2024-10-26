use aiken/collection/dict.{Dict}
use aiken/collection/list
use aiken/crypto.{DataHash, VerificationKeyHash}
use cardano/address.{Address}
use cardano/transaction.{
  DatumHash, InlineDatum, Input, NoDatum, Output, OutputReference, Transaction,
}

pub type SavingsDatum {
  saver: VerificationKeyHash,
}

/// - `0`: Withdraw
/// - `1`: Increase deposit
type Action =
   Int

validator savings {
  spend(
    datum: Option<SavingsDatum>,
    redeemer: Action,
    target: OutputReference,
    tx_info: Transaction,
  ) {
    expect Some(datum) = datum

    when redeemer is {
      // Withdraw:
      0 -> signed_by(datum.saver, tx_info.extra_signatories)

      // Increase deposit:
      1 ->
        signed_by(datum.saver, tx_info.extra_signatories) && updating_savings(
          datum,
          tx_info,
          target,
        )

      _ -> fail @"Invalid action"
    }
  }

  else(_) {
    fail
  }
}

fn signed_by(
  signer: VerificationKeyHash,
  signatories: List<VerificationKeyHash>,
) {
  list.has(signatories, signer)
}

fn updating_savings(
  datum: SavingsDatum,
  tx_info: Transaction,
  utxo_ref: OutputReference,
) -> Bool {
  let c_datum: (DataHash, Data) = complete_datum(datum, tx_info.datums)
  let address: Address = find_input_address(utxo_ref, tx_info.inputs)

  updated_output(c_datum, tx_info.outputs, address)
}

fn find_input_address(utxo_ref: OutputReference, inputs: List<Input>) -> Address {
  expect Some(input_utxo) = transaction.find_input(inputs, utxo_ref)
  input_utxo.output.address
}

fn complete_datum(
  input_datum: SavingsDatum,
  datums: Dict<DataHash, Data>,
) -> (DataHash, Data) {
  expect Some(data_hash) = dict.find(datums, input_datum)

  let data_hash: DataHash = data_hash
  let data: Data = input_datum

  (data_hash, data)
}

fn updated_output(
  input_datum: (DataHash, Data),
  outputs: List<Output>,
  address: Address,
) -> Bool {
  let counter =
    list.count(
      outputs,
      fn(output) -> Bool {
        output.address == address && when output.datum is {
          NoDatum -> False
          DatumHash(datum_hash) -> datum_hash == input_datum.1st
          InlineDatum(datum_data) -> datum_data == input_datum.2nd
        }
      },
    )

  counter == 1
}

/// Tests
test datum_test() {
  let data1: Data = SavingsDatum { saver: "AFD81" }
  let data2: Data = SavingsDatum { saver: "AFD82" }
  let data3: Data = SavingsDatum { saver: "AFD83" }
  let data4: Data = SavingsDatum { saver: "AFD84" }

  let datumst =
    dict.empty
      |> dict.insert("AFD81", data1)
      |> dict.insert("AFD82", data2)
      |> dict.insert("AFD83", data3)
      |> dict.insert("AFD84", data4)

  complete_datum(SavingsDatum { saver: "AFD81" }, datumst) == ("AFD81", data1)
}
