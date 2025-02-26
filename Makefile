init: precheck update clean goat geth contracts
	npm ci
	cp example.json config.json
	sh ./init.sh

start:
	./node_modules/.bin/pm2 start ./build/geth -- --datadir ./data/geth --gcmode=archive --goat.preset=rpc --nodiscover
	./node_modules/.bin/pm2 start ./build/goatd -- start --home ./data/goat --regtest --goat.geth ./data/geth/geth.ipc

stop:
	./node_modules/.bin/pm2 delete all || echo "stopped"
	./node_modules/.bin/pm2 flush

logs:
	./node_modules/.bin/pm2 logs all

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
	rm -rf build data/goat data/geth

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
