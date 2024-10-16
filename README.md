# regtest

## Prerequisite

- docker/docker-compose
- go 1.23
- node lts
- jq

## Steps

### Init

```
git clone --recurse-submodules https://github.com/GOATNetwork/goat-regtest.git
cd goat-regtest
make init
```

### Init genesis config

Add validator

```sh
cp example.json config.json
./build/goatd init --home ./data/goat --chain-id regtest regtest
./build/goatd --home ./data/goat modgen locking sign --owner 0xbc000FE892bC88F2ba41d70aF9F80619F556dCA2
```

Update field `.Locking.validators` of `config.json` like following:

```json
{
  "Locking": {
    "validators": [
      {
        "owner": "0xbc000fe892bc88f2ba41d70af9f80619f556dca2",
        "pubkey": "0x46554f3be17f9f949bfeea66848b536c63011ea6ff31861d3692a1aebeab6559026db2e7132951f0a5b61cd3ff6a1aee5cdb1ae9d1559996ab39357b06125074",
        "signature": "0x46b61b3e3de164126a05d98c688180b7a0eff2ca4f42a80c53faa58bbc7eb9ac6997709b89751bd8f124c69ee1fd92d810f19c1970831ce1801ea87da9e6e92900"
      }
    ]
  }
}
```

Add voters

```sh
./build/goatd ./build/goatd --home ./data/goat modgen keygen --tx --vote
```

Keep the secrete keys and add the pubkeys to field `.Relayer.voters` of `config.json` like following:

```json
{
  "Relayer": {
    "owner": "0xbc000FE892bC88F2ba41d70aF9F80619F556dCA2",
    "voters": [
      {
        "txKey": "0260b5574f71467406fb1ed5ddb5175800d456718d38e9b88881e3327b26134063",
        "voteKey": "aed907a24f714a019581ad47b48eb159dfaa61cdb8156cbebe31c59a519920e96a4e2915d5ad7c05e2c98906f95a3eff052af87752f77678c873c6fdd7718e6bbe592a0d9bd27aded773c4e59cd3cac7086b49d953c22142e247b86f6436d7d3"
      }
    ]
  }
}
```

Update relayer tss group pubkey, it's the default pubkey for deposits

```json
{
  "Consensus": {
    "Relayer": {
      "tssPubkey": "secp256k1/schnoor public key"
    }
  }
}
```

The default owner address is

```json
{
  "Address": "0xbc000FE892bC88F2ba41d70aF9F80619F556dCA2",
  "PrivateKey": "0xdd11c21661a3f7e62fe9d53dc38f85adc96e9bdf0be781d770b7789c545e107f",
  "PublicKey": "0x04b46f2e2e387cbc2bfb541da34d5149256f593a3c175b18004ba21db23d2b8c2483c50b47633831832959aafa88fa5710dd4e649a3203564f6eef75ec5a5fd000"
}
```

You can just update the `.owner` field in the `config.json` to use your own address.

### Create genesis

```sh
cp config.json submodule/contracts/genesis
cd submodule/contracts
npm run genesis
cp ./genesis/regtest.json ./genesis/config.json ../../data/geth
cd -
./build/geth init --datadir ./data/geth ./data/geth/regtest.json
./submodule/goat/contrib/scripts/genesis.sh ./data/goat ./data/geth/config.json ./data/geth/regtest.json
```

### Start

```
./build/geth --datadir ./data/geth --nodiscover
./build/goatd start --home ./data/goat --api.enable --goat.geth ./data/geth/geth.ipc
```

### Cleanup

```sh
make clean
```
