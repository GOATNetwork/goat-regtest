init: clean goat geth contracts

goat:
	mkdir -p build data/goat
	make -C submodule/goat build
	cp submodule/goat/build/goatd build

geth:
	mkdir -p build data/geth
	make -C submodule/geth geth
	cp submodule/geth/build/bin/geth build

contracts:
	npm ci --prefix submodule/contracts
	npm --prefix submodule/contracts run compile

clean:
	rm -rf build
	rm -rf data/regtest data/goat data/geth
	rm -rf submodule/contracts/node_modules
	rm -rf config.json
	rm -rf submodule/contracts/cache submodule/contracts/artifacts submodule/contracts/typechain-types
	rm -rf submodule/contracts/genesis/config.json submodule/contracts/genesis/regtest.json
