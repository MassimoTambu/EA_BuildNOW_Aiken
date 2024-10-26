script_utxo="601ddec84e7888d0d38c1622657b556f7f0e35b3afd6217b665c09c3e774d122#0"
script_address=$(cat ../compiled/savings_v1.addr) 
ref_script_utxo="5284cf2eb91ed7696779c6dc627e35a4e486b750a40f1e47f813157efe51dbb0#1"
user_utxo="690813569f2cf691442fe0e9d1d5c158852f203041e4e69546c8ff2f0451a025#1"
output="260000000"
saverPKH=$(cat $HOME/Dev/Wallets/Adr08.pkh)
collateralPKH=$(cat $HOME/Dev/Wallets/Adr07.pkh)
collateral="4cbf990857530696a12b0062546a4b123ad0bef21c67562e32d03e3288bdcd7b#0"

cardano-cli conway transaction build \
  $PREVIEW \
  --tx-in $script_utxo \
  --spending-tx-in-reference $ref_script_utxo \
  --spending-plutus-script-v3 \
  --spending-reference-tx-in-inline-datum-present \
  --spending-reference-tx-in-redeemer-file ../values/value1.json\
  --tx-in $user_utxo \
  --required-signer-hash $saverPKH \
  --tx-in-collateral $collateral \
  --tx-out $script_address+$output \
  --tx-out-datum-hash-file ../values/saver.json \
  --change-address $nami3 \
  --out-file another_deposit_V2.unsigned

# cardano-cli conway transaction sign \
#     --tx-body-file another_deposit_V2.unsigned \
#     --signing-key-file $HOME/Dev/Wallets/Adr02.skey \
#     --signing-key-file $HOME/Dev/Wallets/Adr07.skey \
#     $PREVIEW \
#     --out-file another_deposit_V2.signed

# cardano-cli conway transaction submit \
#     $PREVIEW \
#     --tx-file another_deposit_V2.signed