import {Lucid, Blockfrost, Credential, Data, Constr} from "npm:@lucid-evolution/lucid";
import {applyParamsToScript} from "npm:@lucid-evolution/utils";
import * as CML from "npm:@anastasia-labs/cardano-multiplatform-lib-nodejs";

const utxoRef = new Constr(0, ["946500cb21ac2f0e1645e11632f53cef21b3e28b3993e7ea910cfd96fbc7e424", BigInt(0) ]);
const tokenName = ("576f575f4e46542dcebb2df09f90a6f09f988d");

const cbor_data = Data.to(utxoRef);
const script_data = Data.from(cbor_data);

const tn_data = Data.to(tokenName);
const tn_script_data = Data.from(tn_data); 


console.log("CBOR:" + cbor_data);
console.log("");
console.log("Value: ");
console.log(script_data);

console.log("CBOR:" + tn_data);
console.log("");
console.log("Value: ");
console.log(tn_script_data);
