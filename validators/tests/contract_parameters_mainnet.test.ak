use aiken/cbor
use aiken/primitive/bytearray

const parameters_bootstrap_utxo_hash =
  #"1168d4a03ae8293f9d8d9260a5c29b7215eb21a110bc0e3c4b90c33adbfebe5f"

const parameters_bootstrap_utxo_idx = 3

test serialise_params_bootstrap() {
  trace bytearray.to_hex(cbor.serialise(parameters_bootstrap_utxo_hash))
  trace bytearray.to_hex(cbor.serialise(parameters_bootstrap_utxo_idx))
  True
}

const fluid_policy_id =
  #"577f0b1342f8f8f4aed3388b80a8535812950c7a892495c0ecdf0f1e"

const fluid_asset_name = #"0014df10464c4454"

const parameter_contract_hash =
  #"3c06ca4ead835e95ced9ca720a35b0b082e4660ad83aeb51062253e1"

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
