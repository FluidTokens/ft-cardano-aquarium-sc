use aiken/collection/list
use cardano/address.{Address, Inline, Script, VerificationKey}
use cardano/assets.{Value, quantity_of, reduce}
use cardano/transaction.{Input, Output, OutputReference, Transaction}
use types/datum.{DatumTank}
use types/redeemer.{Consume, ConsumeAll, RedeemerTank, Withdraw}

validator tank_sponsor(
  _stakingContract: ByteArray,
  params_contract_hash: ByteArray,
) {
  spend(
    datum: Option<DatumTank>,
    redeemer: RedeemerTank,
    own_ref: OutputReference,
    self: Transaction,
  ) {
    expect Some(input) =
      self.inputs
        |> transaction.find_input(own_ref)
    expect Script(ownScriptHash) = input.output.address.payment_credential
    let tank_inputs = get_inputs_from_sc(self.inputs, ownScriptHash)

    when datum is {
      None ->
        when input.output.address.stake_credential is {
          None -> False
          Some(stake_cred) ->
            when stake_cred is {
              Inline(a) -> {
                expect VerificationKey(hash) = a
                list.has(self.extra_signatories, hash)
              }
              _ -> False
            }
        }
      Some(datum) ->
        when redeemer is {
          Consume(
            _payingTokenIndex,
            inputTankIndex,
            _receivers,
            reference_params_index,
            whitelist_index,
          ) -> {
            expect Some(inputTank) = list.at(tank_inputs, inputTankIndex)
            expect Some(outputTank) = list.at(self.outputs, inputTankIndex)
            expect Some(referenceInputParams) =
              list.at(self.reference_inputs, reference_params_index)

            and {
              list.length(tank_inputs) == 1,
              own_ref == inputTank.output_reference,
              validate_tank_output(inputTank, outputTank),
              isWhitelisted(self, datum.whitelistedAddresses, whitelist_index),
              quantity_of(
                referenceInputParams.output.value,
                params_contract_hash,
                "parameters",
              ) == 1,
            }
          }

          ConsumeAll(
            _payingTokenIndex,
            inputTankIndex,
            _receivers,
            reference_params_index,
            whitelist_index,
          ) -> {
            expect Some(inputTank) = list.at(tank_inputs, inputTankIndex)

            expect Some(referenceInputParams) =
              list.at(self.reference_inputs, reference_params_index)

            and {
              own_ref == inputTank.output_reference,
              // verify that the paying token is greater than the fee
              list.length(tank_inputs) == 1,
              isWhitelisted(self, datum.whitelistedAddresses, whitelist_index),
              quantity_of(
                referenceInputParams.output.value,
                params_contract_hash,
                "parameters",
              ) == 1,
            }
          }

          Withdraw -> must_be_signed_by_user_contract(self, datum.tankOwner)

          _ -> False
        }
    }
  }

  else(_) {
    fail
  }
}

fn validate_tank_output(inputTank: Input, outputTank: Output) {
  and {
    check_dos_protection(outputTank.value),
    // verify that the input tank datum is equal to the output tank datum
    inputTank.output.datum == outputTank.datum,
    outputTank.address == inputTank.output.address,
  }
}

fn check_dos_protection(value: Value) {
  reduce(value, 0, fn(_, _, _, count) { count + 1 }) <= 5
}

fn must_be_signed_by_user_contract(transaction: Transaction, address: Address) {
  let input_addresses =
    list.foldl(transaction.inputs, [], fn(x, xs) { [x.output.address, ..xs] })

  let spending_key =
    when address.payment_credential is {
      Script(hash) -> hash
      VerificationKey(hash) -> hash
    }

  or {
    list.has(input_addresses, address),
    list.has(transaction.extra_signatories, spending_key),
  }
}

fn isWhitelisted(
  transaction: Transaction,
  whitelistedAddresses: List<Address>,
  index: Int,
) {
  if list.length(whitelistedAddresses) > 0 {
    expect Some(whitelisted) = list.at(whitelistedAddresses, index)
    must_be_signed_by_user_contract(transaction, whitelisted)
  } else {
    True
  }
}

fn is_output_to_sc(output: Output, scHash: ByteArray) -> Bool {
  when output.address.payment_credential is {
    Script(hash) -> hash == scHash
    _ -> False
  }
}

fn get_inputs_from_sc(inputs: List<Input>, scHash: ByteArray) -> List<Input> {
  list.filter(inputs, fn(input) { is_output_to_sc(input.output, scHash) })
}
