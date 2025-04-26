AIKEN=$1

echo "${AIKEN}"

aiken() {
  ${AIKEN} $*
}

# exit 0

# aiken build -t verbose &> /dev/null
aiken build &> /dev/null

## PREVIEW ##
PREVIEW_PARAMS_BOOTSTRAP_UTXO_HASH=5820D35F81F6BC88BABE5DCF088E3A800ECBB4D75373DF6B144F7561D393CB5D9B2F
PREVIEW_PARAMS_BOOTSTRAP_UTXO_IDX=01

PREVIEW_PARAMS_CONTRACT_HASH=581C1DC94155A9550A0A0C9B6A0F4D609265E0E7D385A2E4535C9D4CBA76
PREVIEW_FLDT_POLICY=581C0B77D150C275BD0A600633E4BE7D09F83C4B9F00981E22AC9C9D3F62
PREVIEW_FLDT_ASSET=490014DF1074464C4454

PREVIEW_STAKER_HASH=581C655BACB11218D31F42BB88400CF733846843D0850D8C109396E34AE4

# Parameters
aiken blueprint apply -v parameters $PREVIEW_PARAMS_BOOTSTRAP_UTXO_HASH -o plutus-tmp.json
mv plutus-tmp.json plutus.json

aiken blueprint apply -m parameters -v parameters $PREVIEW_PARAMS_BOOTSTRAP_UTXO_IDX -o plutus-tmp.json
mv plutus-tmp.json plutus.json

# Staker
aiken blueprint apply -m staker -v staker $PREVIEW_PARAMS_CONTRACT_HASH -o plutus-tmp.json
mv plutus-tmp.json plutus.json
aiken blueprint apply -m staker -v staker $PREVIEW_FLDT_POLICY -o plutus-tmp.json
mv plutus-tmp.json plutus.json
aiken blueprint apply -m staker -v staker $PREVIEW_FLDT_ASSET -o plutus-tmp.json
mv plutus-tmp.json plutus.json

# Tank
aiken blueprint apply -m tank -v tank $PREVIEW_STAKER_HASH -o plutus-tmp.json
mv plutus-tmp.json plutus.json
aiken blueprint apply -m tank -v tank $PREVIEW_PARAMS_CONTRACT_HASH -o plutus-tmp.json
mv plutus-tmp.json plutus-pv.json

aiken build &> /dev/null

# ## MAINNET ##
# MAINNET_PARAMS_BOOTSTRAP_UTXO_HASH=58201168D4A03AE8293F9D8D9260A5C29B7215EB21A110BC0E3C4B90C33ADBFEBE5F
# MAINNET_PARAMS_BOOTSTRAP_UTXO_IDX=03

# MAINNET_PARAMS_CONTRACT_HASH=581C3C06CA4EAD835E95CED9CA720A35B0B082E4660AD83AEB51062253E1
# MAINNET_FLDT_POLICY=581C577F0B1342F8F8F4AED3388B80A8535812950C7A892495C0ECDF0F1E
# MAINNET_FLDT_ASSET=480014DF10464C4454

# MAINNET_STAKER_HASH=581C6A991151C6E5C186E977930E296FCC6D9D69DED149A5113CCD1CA5E7

# # Parameters
# aiken blueprint apply -v parameters $MAINNET_PARAMS_BOOTSTRAP_UTXO_HASH -o plutus-tmp.json
# mv plutus-tmp.json plutus.json

# aiken blueprint apply -v parameters $MAINNET_PARAMS_BOOTSTRAP_UTXO_IDX -o plutus-tmp.json
# mv plutus-tmp.json plutus.json

# # Staker
# aiken blueprint apply -m staker -v staker $MAINNET_PARAMS_CONTRACT_HASH -o plutus-tmp.json
# mv plutus-tmp.json plutus.json
# aiken blueprint apply -m staker -v staker $MAINNET_FLDT_POLICY -o plutus-tmp.json
# mv plutus-tmp.json plutus.json
# aiken blueprint apply -m staker -v staker $MAINNET_FLDT_ASSET -o plutus-tmp.json
# mv plutus-tmp.json plutus.json

# # Tank
# aiken blueprint apply -m tank -v tank $MAINNET_STAKER_HASH -o plutus-tmp.json
# mv plutus-tmp.json plutus.json
# aiken blueprint apply -m tank -v tank $MAINNET_PARAMS_CONTRACT_HASH -o plutus-tmp.json
# mv plutus-tmp.json plutus-mn.json

# aiken build &> /dev/null
