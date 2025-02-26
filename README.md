# regtest

## Prerequisite

- docker/docker-compose
- go
- node
- jq

### Quick start

```sh
git clone --recurse-submodules https://github.com/GOATNetwork/goat-regtest.git
cd goat-regtest
make init start
```

Now you have a web3 jsonrpc on 8545 port and consensus rest api on 1317 port

### Logs

```sh
make logs
```

### Stop

```sh
make stop
```

### Cleanup

```sh
make clean
```

### Config

If you want to have your own setup, please check out the Makefile script and the [config defination file](https://github.com/GOATNetwork/goat-contracts/blob/main/task/deploy/param.ts)

Note: the default owner address and relayer tss group public key

```json
{
  "Address": "0xbc000FE892bC88F2ba41d70aF9F80619F556dCA2",
  "PrivateKey": "0xdd11c21661a3f7e62fe9d53dc38f85adc96e9bdf0be781d770b7789c545e107f",
  "PublicKey": "0x02b46f2e2e387cbc2bfb541da34d5149256f593a3c175b18004ba21db23d2b8c24"
}
```

You will have 1,000 BTC in the the address by default
