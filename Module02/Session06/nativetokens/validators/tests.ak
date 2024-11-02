// use ea_coins
use ea_nft.{ConditionsRedeemer, Action, utxo_spent}
use cardano/transaction.{OutputReference}
use nativetokens/utils



test nft_test() {
    and{mint_ea_coins(),
        mint_ea_nft(),
        burn_ea_coins(),
        burn_ea_nft()}
}

fn mint_ea_coins() {True}

fn burn_ea_coins()  {True}

fn mint_ea_nft() {True}

fn burn_ea_nft() {True}


test utxo_spent_test() {
  let utxo_ref =
    OutputReference(
      #"0000000000000000000000000000000000000000000000000000000000000000",
      0,
    )
  let tx = utils.dummy_transaction()
  utxo_spent(utxo_ref, tx)?
}


