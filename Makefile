# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

install: solc update npm

# dapp deps
update:; dapp update

# install solc version
# example to install other versions: `make solc 0_8_2`
SOLC_VERSION=0_8_12
solc:; nix-env -f https://github.com/dapphub/dapptools/archive/master.tar.gz -iA solc-static-versions.solc_${SOLC_VERSION}

# Build & Test
all    		:; dapp build
clean  		:; dapp clean && rm -rf ./tmp/*
test   		:; dapp test -v
fuzz   		:; dapp test --fuzz-runs 100
debug  		:; dapp debug 
estimate 	:; ./scripts/estimate-gas.sh ${contract}
size   		:; ./scripts/contract-size.sh ${contract}

# Deployment Helper
deploy :; ./bin/deploy.sh

# Mainet
deploy-mainnet: export ETH_RPC_URL = $(call network,mainnet)
deploy-mainnet: export NETWORK=mainnet
deploy-mainnet: check-api-key deploy

# Rinkeby
deploy-rinkeby: export ETH_RPC_URL = $(call network,rinkeby)
deploy-rinkeby: export NETWORK=rinkeby
deploy-rinkeby: check-api-key deploy

# Spark
deploy-spark: export ETH_RPC_URL = https://rpc.fusespark.io 
deploy-spark: export NETWORK=rinkeby
deploy-spark: check-api-key deploy

# Fuse
deploy-fuse: export ETH_RPC_URL = https://rpc.fuse.io 
deploy-fuse: export NETWORK=fuse
deploy-fuse: check-api-key deploy

check-api-key:
ifndef INFURA_API_KEY
	$(error INFURA_API_KEY is undefined)
endif

# Returns the URL to deploy to a hosted node.
# Requires the ALCHEMY_API_KEY env var to be set.
# The first argument determines the network (mainnet / rinkeby / ropsten / kovan / goerli)
define network
https://$1.infura.io/v3/${INFURA_API_KEY}
endef


# USAGE: make sym ADD=0xAA55E0ca7115e068954526ddE18D929F2A2e572e
sym:
	hevm symbolic --rpc $(ETH_GOER) --address $(ADD) --solver cvc4 --debug

# CREATE TRANSACTION
create-tx:
	seth mktx --rpc-url $(ARB_RINKEBY) \
		--keystore $(KEYSTORE) \
		--from $(WALLET_DISK) --gas $(GAS) \
		0xC0aE9A2c75c79Dd4cAc0a9708154FB4033219014 \
		'adopt(uint)' '5'


# auto-recompile [install inotify-tools before]
watch-compile:
	fswatch -m poll_monitor -or ./src | xargs -I{} sh -c "clear && dapp build"

watch-test:
	fswatch -m poll_monitor -or ./src | xargs -I{} sh -c "clear && dapp test -v"

optimze:
	DAPP_STANDARD_JSON="config.json" \
	DAPP_SOLC_OPTIMIZE=true \
	DAPP_SOLC_OPTIMIZE_RUNS=1 \
	SOLC_FLAGS="--optimize --optimize-runs=1" \
	dapp --use solc:$(SOLC_VERSION) build


# update nix
update-nix:
	nix-channel --update && nix-env --upgrade

# start node poanetwork.dev chain:99
# https://github.com/dapphub/dapptools/blob/master/src/dapp/docs/testnet.rst
testnet:
	dapp testnet --rpc-port=8545 --chain-id=42


# Keystore Manipulation
inspect:
	ethkey inspect --private keys/keystore-55a9

import:
	ethsign import

balance:
	seth balance $(ETH_FROM) | seth --from-wei

remote-debug:
	hevm symbolic --rpc $(ETH_GOER) \
		--address 0x5d9c15e68048e480e2d1396fba888cc050843376 \
		--solver cvc4 --debug --json-file ./out/dapp.sol.json

check-trace:
	curl --location --request POST 'https://rpc.' \
--header 'Content-Type: application/json' \
--data-raw '{ "jsonrpc":"2.0", "method":"trace_replayTransaction","params":["0xb2b0e7b286e83255928f81713ff416e6b8d0854706366b6a9ace46a88095f024", ["trace"]],"id":1}'
