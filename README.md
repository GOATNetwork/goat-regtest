# regtest

## Prerequisite

- docker/docker-compose
- go 1.23
- node lts
- jq

## Steps

Note: the default owner address and relayer tss group public key

```json
{
  "Address": "0xbc000FE892bC88F2ba41d70aF9F80619F556dCA2",
  "PrivateKey": "0xdd11c21661a3f7e62fe9d53dc38f85adc96e9bdf0be781d770b7789c545e107f",
  "PublicKey": "0x02b46f2e2e387cbc2bfb541da34d5149256f593a3c175b18004ba21db23d2b8c24"
}
```

### Init

Clone this repository

```sh
git clone --recurse-submodules https://github.com/GOATNetwork/goat-regtest.git
cd goat-regtest
```

Add validator to genesis

```sh
make init
cp example.json config.json
./build/goatd --home ./data/goat modgen init --chain-id regtest regtest
VALIDATOR=$(./build/goatd --home ./data/goat modgen locking sign --owner 0xbc000FE892bC88F2ba41d70aF9F80619F556dCA2)
jq --argjson new_data "$VALIDATOR" '.Locking.validators += [$new_data]' config.json > tmp.json && mv tmp.json config.json
```

Add voters to genesis

```sh
VOTER=$(./build/goatd --home ./data/goat modgen relayer keygen)
jq --argjson new_data "$VOTER" '.Relayer.voters += [$new_data]' config.json > tmp.json && mv tmp.json config.json
```

The output of the first line command above is the the private key of the tx key and vote key.

Change other configuration fileds

https://github.com/GOATNetwork/goat-contracts/blob/main/task/deploy/param.ts

### Create genesis

```sh
npm --prefix submodule/contracts run genesis -- --param ../../config.json
./build/geth init --db.engine pebble --state.scheme hash --cache.preimages --datadir ./data/geth ./submodule/contracts/genesis/regtest.json
./submodule/goat/contrib/scripts/genesis.sh ./data/goat ./config.json ./submodule/contracts/genesis/regtest.json
```

### Start

geth(execution client)

```sh
./build/geth --datadir ./data/geth --gcmode=archive --http --http.api=eth,net,web3,debug --nodiscover
```

goat(consensus client)

```sh
./build/goatd start --home ./data/goat --api.enable --goat.geth ./data/geth/geth.ipc --p2p.pex false
```

### Cleanup

```sh
make clean
```
