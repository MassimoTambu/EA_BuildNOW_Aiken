utxoin1="7f1409ec3e5861a6371a3b9a10117538177d11d3dbba056254d12b4b14699145#4"
policyid=$(cat ak_eaCoins.pid)
output="2200000000"
tokenamount="100"
tokenname="$(echo -n "no_name_token" | xxd -ps | tr -d '\n')"
mintingScript="./compiled/ak_eaCoins.uplc"
collateral="e623894e267cf3d4553327108d566d61b01298a1b56363b260ffb5e768578913#0"
signerPKH="2070f8488dd696b78a5f23e38d273550e43660526c4b19cba733b488"
ownerPKH="d40e3e791bead1fd8c003f1227906b66a2a1c04e59d663798017db71"
notneeded="--invalid-hereafter 10962786"
PREVIEW = "--testnet-magic 2"

cardano-cli conway transaction build \
  $PREVIEW \
  --tx-in $utxoin1 \
  --required-signer-hash $ownerPKH \
  --required-signer-hash $signerPKH \
  --tx-in-collateral $collateral \
  --tx-out $nami3+$output+"$tokenamount $policyid.$tokenname" \
  --change-address $nami3 \
  --mint "$tokenamount $policyid.$tokenname" \
  --mint-script-file $mintingScript \
  --mint-redeemer-file ./values/redeemer.json \
  --out-file mintTx.unsigned

# cardano-cli conway transaction sign \
#     --tx-body-file mintTx.unsigned \
#     --signing-key-file ../../../Wallets/Adr12.skey \
#     --signing-key-file ../../../Wallets/Adr11.skey \
#     $PREVIEW \
#     --out-file mintTx.signed

#  cardano-cli conway transaction submit \
#     $PREVIEW \
#     --tx-file mintTx.signed