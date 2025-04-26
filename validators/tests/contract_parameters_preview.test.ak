use aiken/cbor
use aiken/primitive/bytearray

const parameters_bootstrap_utxo_hash =
  #"d35f81f6bc88babe5dcf088e3a800ecbb4d75373df6b144f7561d393cb5d9b2f"

const parameters_bootstrap_utxo_idx = 1

test serialise_params_bootstrap() {
  trace bytearray.to_hex(cbor.serialise(parameters_bootstrap_utxo_hash))
  trace bytearray.to_hex(cbor.serialise(parameters_bootstrap_utxo_idx))
  True
}

const fluid_policy_id =
  #"0b77d150c275bd0a600633e4be7d09f83c4b9f00981e22ac9c9d3f62"

const fluid_asset_name = #"0014df1074464c4454"

const parameter_contract_hash =
  #"1dc94155a9550a0a0c9b6a0f4d609265e0e7d385a2e4535c9d4cba76"

test serialise_staker_cotract_parameters() {
  //  params_contract_hash: ByteArray,
  // fldt_policy: ByteArray,
  // fldt_asset: ByteArray,
  trace bytearray.to_hex(cbor.serialise(parameter_contract_hash))
  trace bytearray.to_hex(cbor.serialise(fluid_policy_id))
  trace bytearray.to_hex(cbor.serialise(fluid_asset_name))
  True
}

const staker_script_hash =
  #"655bacb11218d31f42bb88400cf733846843d0850d8c109396e34ae4"

test serialise_staker_script_hash() {
  trace bytearray.to_hex(cbor.serialise(staker_script_hash))
  True
}
