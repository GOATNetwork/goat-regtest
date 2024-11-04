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
