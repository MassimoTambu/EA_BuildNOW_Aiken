use campaign_management_v01.{CFdatum, CFredeemer}
use cardano/transaction.{OutputReference, Transaction}

test cancel_campaign_v01() {
  let utxo_ref = OutputReference("", 0)
  let datum =
    CFdatum {
      campaign_id: 1,
      title: "Demo Campaign ",
      goal: 100000000,
      creator: "AFDA",
      backer: "",
      amount: 0,
      deadline: 100,
      current_funds: 0,
    }
  let wrong_datum =
    CFdatum {
      campaign_id: 1,
      title: "Demo Campaign ",
      goal: 0,
      creator: "",
      backer: "AFDB",
      amount: 10_000_000,
      deadline: 0,
      current_funds: 0,
    }
  let redeemer = CFredeemer { campaign_id: 1, action: 0, amount: 0, backer: "" }
  let tx_info =
    Transaction { ..transaction.placeholder, extra_signatories: ["AFDA"] }
  and {
    campaign_management_v01.manage_campaign.spend(
      Some(datum),
      redeemer,
      utxo_ref,
      tx_info,
    ),
    campaign_management_v01.manage_campaign.spend(
      Some(wrong_datum),
      redeemer,
      utxo_ref,
      tx_info,
    ) == False,
  }
}
// test update_campaign_v01() {}
