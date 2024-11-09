use aiken/collection/list
use aiken/crypto.{VerificationKeyHash}
use cardano/transaction.{OutputReference, Transaction}

/// shorthand notation for custom types
/// the full version would have the explicit Data Constructor like
/// type Datum { Datum {...fields are the same...} }
pub type CFdatum = CFdatum {
  campaign_id: Int,
  title: ByteArray,
  goal: Int,
  creator: VerificationKeyHash,
  backer: VerificationKeyHash,
  amount: Int,
  deadline: Int,
  current_funds: Int,
}

/// Actions Enumerator
///  0 -> Cancel Campaign
///  1 -> Support Campaign
///  2 -> 
///
pub type Action =
  Int

pub type CFredeemer {
  campaign_id: Int,
  action: Action,
  amount: Int,
  backer: VerificationKeyHash,
}

validator manage_campaign {
  spend(
    datum: Option<CFdatum>,
    redeemer: CFredeemer,
    _utxo: OutputReference,
    transaction: Transaction,
  ) {
    expect Some(datum) = datum

    when redeemer.action is {
      0 ->
        cancel_campaign(
          datum,
          redeemer.campaign_id,
          transaction.extra_signatories,
        )

      1 ->
        support_campaign(
          datum,
          redeemer.campaign_id,
          transaction.extra_signatories,
        )

      2 -> claims(datum, redeemer.campaign_id, transaction.extra_signatories)
      _ -> fail
    }
  }

  else(_) {
    fail
  }
}

/// Cancellation conditions
///  Datum.campaignId == Redeemer.campaignId
///  Datum.creator => Authorize transaction by signing it.
///  Datum.current_funds == 0
///  Datum.amount == 0
///
fn cancel_campaign(
  datum: CFdatum,
  campaign_id: Int,
  signatories: List<VerificationKeyHash>,
) -> Bool {
  datum.campaign_id == campaign_id && datum.current_funds == 0 && datum.amount == 0 && datum.backer == "" && must_be_signed_by(
    datum.creator,
    signatories,
  )
}



/// Update conditions
///    Datum.campaignId == Redeemer.campaignId
///    Datum.backer => Authorize his support by signing the transaction.
///
fn support_campaign(
  datum: CFdatum,
  campaign_id: Int,
  signatories: List<VerificationKeyHash>,
) -> Bool {
  datum.campaign_id == campaign_id && must_be_signed_by(
    datum.backer,
    signatories,
  )
}

/// Claims conditions
///   Datum.campaignId == Redeemer.campaignId
///   Datum.current_funds >= Datum.goal
///   Datum.creator => Authorize transaction by signingn it.
///
fn claims(
  datum: CFdatum,
  campaign_id: Int,
  signatories: List<VerificationKeyHash>,
) -> Bool {
  datum.campaign_id == campaign_id && datum.current_funds >= datum.goal && must_be_signed_by(
    datum.creator,
    signatories,
  )
}

fn must_be_signed_by(
  signer: VerificationKeyHash,
  signatories: List<VerificationKeyHash>,
) -> Bool {
  // The verificationKeyHash is the hash of the verification key of the signature
  list.has(signatories, signer)
}

// This contract is like swiss cheese, full of holes.