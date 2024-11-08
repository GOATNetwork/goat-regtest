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
./build/goatd --home ./data/goat modgen init --regtest --chain-id regtest regtest
VALIDATOR=$(./build/goatd --home ./data/goat modgen locking sign --owner 0xbc000FE892bC88F2ba41d70aF9F80619F556dCA2)
jq --argjson new_data "$VALIDATOR" '.Locking.validators += [$new_data]' config.json > tmp.json && mv tmp.json config.json
```

Add voters to genesis

```sh
VOTER=$(./build/goatd --home ./data/goat modgen relayer keygen)
jq --argjson new_data "$VOTER" '.Relayer.voters += [$new_data]' config.json > tmp.json && mv tmp.json config.json
```

The output of the first line command above is the the private key of the tx key and vote key.

Change other configuration fields if you need

https://github.com/GOATNetwork/goat-contracts/blob/main/task/deploy/param.ts

### Initialize genesis state

```sh
npm --prefix submodule/contracts run genesis -- --param ../../config.json --faucet 0xbc000FE892bC88F2ba41d70aF9F80619F556dCA2 --amount 1000
./build/geth init --state.scheme hash --cache.preimages --datadir ./data/geth ./submodule/contracts/genesis/regtest.json
./submodule/goat/contrib/scripts/genesis.sh ./data/goat ./config.json
```

You will have 1,000 BTC in the the default address.

### Start

geth(execution client)

```sh
./build/geth --datadir ./data/geth --gcmode=archive --goat.preset=rpc --nodiscover
```

goat(consensus client)

```sh
./build/goatd start --home ./data/goat --regtest --goat.geth ./data/geth/geth.ipc
```

### Cleanup

```sh
make clean
```
