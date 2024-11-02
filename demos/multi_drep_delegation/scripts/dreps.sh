ERA="conway"
MAGIC=2


cardano-cli $ERA address key-gen \
  --verification-key-file payment.vkey \
  --signing-key-file payment.skey

# Generate Staking Key Pair 1
cardano-cli $ERA stake-address key-gen \
  --verification-key-file stake1.vkey \
  --signing-key-file stake1.skey

# Generate Staking Key Pair 2
cardano-cli $ERA stake-address key-gen \
  --verification-key-file stake2.vkey \
  --signing-key-file stake2.skey

# Build Base Address 1 (with stake key 1)
cardano-cli $ERA address build \
  --payment-verification-key-file payment.vkey \
  --stake-verification-key-file stake1.vkey \
  --out-file base-address1.addr \
  --testnet-magic $MAGIC

# Build Base Address 2 (with stake key 2)
cardano-cli $ERA address build \
  --payment-verification-key-file payment.vkey \
  --stake-verification-key-file stake2.vkey \
  --out-file base-address2.addr \
  --testnet-magic $MAGIC

# Register Stake Key 1
cardano-cli $ERA stake-address registration-certificate \
  --stake-verification-key-file stake1.vkey \
  --out-file stake1.reg.cert

# Register Stake Key 2
cardano-cli $ERA stake-address registration-certificate \
  --stake-verification-key-file stake2.vkey \
  --out-file stake2.reg.cert

# Submit transaction for Stake Key 1 registration
cardano-cli transaction $ERA build \
  --tx-in <TX_IN>#<TX_IDX> \
  --certificate-file stake1.reg.cert \
  --change-address $(cat base-address1.addr) \
  --out-file tx.raw \
  --testnet-magic $MAGIC

cardano-cli transaction $ERA sign \
  --tx-body-file tx.raw \
  --signing-key-file payment.skey \
  --signing-key-file stake1.skey \
  --out-file tx.signed

cardano-cli transaction submit --tx-file tx.signed --mainnet

# Delegate Stake Key 1 to DRep 1
cardano-cli stake-address delegation-certificate \
  --stake-verification-key-file stake1.vkey \
  --stake-pool-id <DREP1_ID> \
  --out-file stake1.deleg.cert

# Delegate Stake Key 2 to DRep 2
cardano-cli stake-address delegation-certificate \
  --stake-verification-key-file stake2.vkey \
  --stake-pool-id <DREP2_ID> \
  --out-file stake2.deleg.cert

# Submit the delegation certificates with a transaction
cardano-cli transaction build \
  --tx-in <TX_IN> \
  --certificate-file stake1.deleg.cert \
  --certificate-file stake2.deleg.cert \
  --change-address $(cat base-address1.addr) \
  --out-file tx.raw

cardano-cli transaction sign \
  --tx-body-file tx.raw \
  --signing-key-file payment.skey \
  --signing-key-file stake1.skey \
  --signing-key-file stake2.skey \
  --out-file tx.signed

cardano-cli transaction submit --tx-file tx.signed --mainnet
