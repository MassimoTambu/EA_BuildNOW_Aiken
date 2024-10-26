utxoin="c97d077954b9e112612c563ca1409befbdb9d39f16e57e6dd4bea5f468d8415a#0"
address=$(cat ../compiled/savings.addr) 
output="5000000000"

cardano-cli conway transaction build \
  $PREVIEW \
  --tx-in $utxoin \
  --tx-out $address+$output \
  --tx-out-datum-hash-file ../values/CFdatum.json \
  --change-address $nami3 \
  --out-file createCampaign.unsigned

cardano-cli conway transaction sign \
    --tx-body-file createCampaign.unsigned \
    --signing-key-file $HOME/Dev/Wallets/Adr08.skey \
    $PREVIEW \
    --out-file createCampaign.signed

cardano-cli conway transaction submit \
    $PREVIEW \
    --tx-file createCampaign.signed