init: precheck clean goat geth contracts
	cp example.json config.json
	sh ./init.sh
	command -v pm2 || npm install pm2 -g

start:
	pm2 start ./build/geth -- --datadir ./data/geth --gcmode=archive --goat.preset=rpc --nodiscover
	pm2 start ./build/goatd -- start --home ./data/goat --regtest --goat.geth ./data/geth/geth.ipc

stop:
	pm2 delete all || echo "stopped"
	pm2 flush

logs:
	pm2 logs all

goat:
	mkdir -p build data/goat
	make -C submodule/goat build
	cp submodule/goat/build/goatd build

geth:
	mkdir -p build data/geth
	make -C submodule/geth geth
	cp submodule/geth/build/bin/geth build

contracts:
	npm ci --engine-strict --prefix submodule/contracts
	npm --prefix submodule/contracts --engine-strict run compile

clean: stop
	rm -rf build
	rm -rf data/goat data/geth
	rm -rf config.json
	rm -rf submodule/contracts/artifacts
	rm -rf submodule/contracts/cache
	rm -rf submodule/contracts/genesis/regtest-config.json
	rm -rf submodule/contracts/genesis/regtest.json
	rm -rf submodule/contracts/typechain-types
	rm -rf submodule/contracts/node_modules
	rm -rf submodule/goat/build
	rm -rf submodule/geth/build/bin

web3:
	@./build/geth attach --datadir ./data/geth

precheck:
	node --version
	go version
	docker --version
	docker compose version
	jq --version

update:
	git submodule update
