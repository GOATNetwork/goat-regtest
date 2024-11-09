#!/bin/sh

set -ex

OWNER='0xbc000FE892bC88F2ba41d70aF9F80619F556dCA2'

./build/goatd --home ./data/goat modgen init --regtest regtest

VALIDATOR=$(./build/goatd --home ./data/goat modgen locking sign --owner $OWNER)
jq --argjson new_data "$VALIDATOR" '.Locking.validators += [$new_data]' config.json > tmp.json && mv tmp.json config.json

VOTER=$(./build/goatd --home ./data/goat modgen relayer keygen --output 1.json)
jq --argjson new_data "$VOTER" '.Relayer.voters += [$new_data]' config.json > tmp.json && mv tmp.json config.json

npm --prefix submodule/contracts run genesis -- --param ../../config.json --faucet $OWNER --amount 1000
./build/geth init --state.scheme hash --cache.preimages --datadir ./data/geth ./submodule/contracts/genesis/regtest.json
./submodule/goat/contrib/scripts/genesis.sh ./data/goat ./config.json
