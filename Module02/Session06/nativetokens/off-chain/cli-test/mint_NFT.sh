utxoin1="946500cb21ac2f0e1645e11632f53cef21b3e28b3993e7ea910cfd96fbc7e424#0"
policyid=$(cat ../compiled/ea_nft.pid)
output="11000000"
tokenamount="1"
tokenname="$(echo -n "WoW_NFT-λ-🐦😍" | xxd -ps | tr -d '\n')"
mintingScript="../compiled/Params_ea_nft.uplc"
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
  --metadata-json-file ../values/NFTmetadata.json \
  --out-file mint_NFT.unsigned

cardano-cli conway transaction sign \
    --tx-body-file mint_NFT.unsigned \
    --signing-key-file $HOME/Dev/Wallets/Bob.skey \
    --signing-key-file $HOME/Dev/Wallets/Adr07.skey \
    $PREVIEW \
    --out-file mint_NFT.signed

 cardano-cli conway transaction submit \
    $PREVIEW \
    --tx-file mint_NFT.signed