#!/bin/bash


#Private Key: 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

# WALLETS
WALLET_DISK=0x4828699dcbe7d449ce209af47ed285eba9a555a9
WALLET_HARDHAT=0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266
WALLET_METAMASK=0x0cde80AD77Ab131510036A72b012a4A0F26C2ACC

# NETWORKS
ETH_RINK=https://rinkeby.infura.io/v3/17509665a88549b9a5a5f8f3e291120c
ETH_GOER=https://goerli.infura.io/v3/17509665a88549b9a5a5f8f3e291120c
ARB_RINK=https://rinkeby.arbitrum.io/rpc
FUSE_MAIN=https://rpc.fuse.io
FUSE_TEST=https://rpc.fusespark.io/
OPT_GOER=https://goerli.optimism.io/

# LOCAL OPT
SEQUENCER=http://localhost:8545
VERIFIER=http://localhost:8547
REPLICA=http://localhost:8549

# tx2uml
ARCHIVE_NODE_URL=https://api.archivenode.io/0e60a7d9-95c6-4f63-b065-1e8bd4f54137

# private key: a6aecc98b63bafb0de3b29ae9964b14acb4086057808be29f90150214ebd4a0f
SYSTEM_ADDRESS_0_DEPLOYER=0xa961b0d6dce82db098cf70a42a14add3ee3db2d5
# private key: 3b8d2345102cce2443acb240db6e87c8edd4bb3f821b17fab8ea2c9da08ea132
SYSTEM_ADDRESS_1_DEPLOYER=0xdfc82d475833a50de90c642770f34a9db7deb725
L1_WALLET=0x70997970c51812dc3a010c7d01b50e0d17dc79c8

# SETH [needs env]
# max gas in fuse genesis is 10000000, so don't try to setup more
# export ETH_KEYSTORE=./keys
# export ETH_PASSWORD=./keys/PASS-55a9
# export ETH_GAS=1000000
# export ETH_GAS_PRICE=10100010000


#name=${1?missing contract name}



export ETH_RPC_URL=$ARCHIVE_NODE_URL
export ETH_FROM=$WALLET_DISK



# GET BALANCES
function balances {
  #declare -a nets=($ETH_RINK $ARB_RINK $FUSE_MAIN $FUSE_TEST $ETH_GOER)
  declare -a nets=($SEQUENCER $VERIFIER $REPLICA)
  for net in ${nets[@]}; 
    do 
      balance=$(seth --rpc-url $net balance $SYSTEM_ADDRESS_0_DEPLOYER | seth --from-wei)
    printf "W-0: %8.4f  $net\n" "$balance"
      balance=$(seth --rpc-url $net balance $SYSTEM_ADDRESS_1_DEPLOYER | seth --from-wei)
    printf "W-1: %8.4f  $net\n" "$balance"
  done
}

# type=$(seth --abi-constructor <<< "$abi")


# LAYER1 - HARDHAT
function opt {
  export ETH_FROM=$WALLET_HARDHAT
  export ETH_RPC_URL=$OPT_LOCAL
  export ETH_PASSWORD=./keys/PASS-2266
  dapp create Election
}

# MULTIPLE DEPLOY
function deploy {
  export ETH_FROM=$WALLET_DISK
  export ETH_RPC_URL=$FUSE_TEST
  dapp create BasicToken 1000
  # export ETH_RPC_URL=$ARB_RINK
  # dapp create Election
}

# done: 0xC0aE9A2c75c79Dd4cAc0a9708154FB4033219014

# get balance
# seth --rpc-url $ARB_RINKEBY balance $WALLET_DISK
#
#
# # send 1 wei from fuse to arbitrum to test
# seth send --value 1 \
#           --rpc-url  $FUSE_MAIN \
#           --keystore $KEYSTORE \
#           --from $WALLET_DISK $WALLET_METAMASK

# seth send --value $(seth --to-wei 0.4) --rpc-url $RINKEBY --keystore ./keys --password ./keys/PASS --from 0x4828699dCbe7D449cE209af47Ed285EbA9A555a9 0xf88a2b84c740C051599DaB734A05C80d7483CA82
