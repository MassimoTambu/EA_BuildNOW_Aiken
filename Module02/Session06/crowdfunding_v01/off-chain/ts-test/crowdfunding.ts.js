import { Lucid, Blockfrost, SpendingValidator, fromHex, toHex, Credential, credentialToAddress } from "https://deno.land/x/lucid@0.10.7/mod.ts";
import * as cbor from "https://deno.land/x/cbor@v1.4.1/index.js";
import test01_signingKey from "../../../Wallets/Adr11skey.json" with {type: 'json'};

const lucid = await Lucid.new(new Blockfrost("https://cardano-preview.blockfrost.io/api/v0", Deno.env.get("BLOCKFROST_PROJECT_ID"),),"Preview");

const paymentCredential: Credential = {
    type: "Key",
    hash: "2070f8488dd696b78a5f23e38d273550e43660526c4b19cba733b488"  //taken from cardano-cli generated verification key hash
};

const stakeCredential: Credential = {
      type: "Key",
      hash: "8662fe85a22159022d71aebcf4342bcafaa6ede0df2e486a4e751e8e" // taken from cardano-cli generated stake verification key hash
  };
const address11 = lucid.utils.credentialToAddress(paymentCredential, stakeCredential);
await Deno.writeTextFile("our.addr", address11);

// Alternative, generate new private keys with Lucid
//  const ourPrivateKey = lucid.utils.generatePrivateKey();
//  await Deno.writeTextFile("OurAddress.skey", ourPrivateKey);


//Cardano Private key in bech32; not the BIP32 private key or any key that is not fully derived. 
// * Only an Enteprise address (without stake credential) is derived.

// const address11 = await lucid
//  //  .selectWalletFromPrivateKey(test01_signingKey.ed25519)  
//    .credentialToAddress(paymentCredential, stakeCredential)
//    .wallet.address();

//read validator from blueprint json file created with aiken

const validator = await readValidator();

async function readValidator(): Promise<SpendingValidator> {
   const validator = JSON.parse(await Deno.readTextFile("../crowdfunding _v02/plutus.json")).validators[0];
   return {
    type: "PlutusV2",
    script: toHex(cbor.encode(fromHex(validator.compiledCode)))
  };
}

console.log(validator);