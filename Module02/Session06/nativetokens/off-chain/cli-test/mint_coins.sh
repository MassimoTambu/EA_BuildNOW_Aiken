utxoin1="544d3e557d10949f9a0f3325c21566f394c7deb7bbd88565e981820abac7d863#0"
policyid=$(cat ../compiled/ea_NFT.pid)
output="11000000"
tokenamount="2"
tokenname="$(echo -n "WoW-λ-🐦😍" | xxd -ps | tr -d '\n')"
mintingScript="../compiled/ea_NFT.uplc"
collateral="4cbf990857530696a12b0062546a4b123ad0bef21c67562e32d03e3288bdcd7b#0"
ownerPKH=$(cat $HOME/Dev/Wallets/Bob.pkh)
notneeded="--invalid-hereafter 10962786"

cardano-cli conway transaction build \
  $PREVIEW \
  --tx-in $utxoin1 \
  --required-signer-hash $ownerPKH \
  --tx-in-collateral $collateral \
  --tx-out $nami3+$output+"$tokenamount $policyid.$tokenname" \
  --change-address $nami3 \
  --mint "$tokenamount $policyid.$tokenname" \
  --mint-script-file $mintingScript \
  --mint-redeemer-file ../values/redeemer.json \
  --out-file mintTx.unsigned

cardano-cli conway transaction sign \
    --tx-body-file mintTx.unsigned \
    --signing-key-file $HOME/Dev/Wallets/Bob.skey \
    --signing-key-file $HOME/Dev/Wallets/Adr07.skey \
    $PREVIEW \
    --out-file mintTx.signed

 cardano-cli conway transaction submit \
    $PREVIEW \
    --tx-file mintTx.signed