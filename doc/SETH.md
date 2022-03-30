# SETH


## Keystore

To create a new account, you must have geth installed.
See
[this](https://julien-maffre.medium.com/what-is-an-ethereum-keystore-file-86c8c5917b97)
article to understand better about keystore.

```
# create new account
geth account new

# see created accounts
geth account list

```

## Testnet

Before starting, probably you want to clean the genesis block

```
# clean all the networks before, if you want, or have some sync error
rm -rf ~/.dapp/testnet

# start the test network
dapp testnet
```

use the sethrc:

```
export ETH_RPC_URL=http://localhost:8545
export chainid=$(seth --to-uint256 99)
export ETH_FROM=$(cat ~/.dapp/testnet/2000/config/account)
```

## Seth

Several scripts to interact and train MakerDao's tools


> The wallets and private keys should never be uploaded to a repository,
> but because we are using only test networks, this PK will only hold non
> valuable tokens



* [example](https://github.com/dapphub/dapptools/tree/master/src/seth#example-sethrc-file)
* [seth](https://github.com/dapphub/dapptools/tree/master/src/seth#example-sethrc-file)
* [makerdao-seth](https://github.com/makerdao/developerguides/blob/master/mcd/mcd-seth/mcd-seth.md)
* [maker-docs](https://docs.makerdao.com/clis/seth)
* [readme](https://github.com/dapphub/dapptools/blob/master/src/seth/README.md)

```

Usage: seth [<options>] <command> [<args>]
   or: seth <command> --help

Perform Ethereum RPC calls from the comfort of your command line.

Connection options:

   --rpc-host=<host>          JSON-RPC host (default: `localhost')
   --rpc-port=<port>          JSON-RPC port (default: `8545')
   --rpc-url=<url>            JSON-RPC URL (overrides host and port)
   --rpc-accounts             use JSON-RPC node for accounts and signing
   -C, --chain=<chain>        remote node configuration preset
   --keystore=<dir>           local keystore directory

Transaction options:

   -F, --from=<sender>        account to send transaction from
   -G, --gas=<number>         number of gas units to provide
   -P, --gas-price=<number>   price (in wei) of each gas unit
   -N, --nonce=<number>       nonce value to use for the transaction
   -V, --value=<number>       amount (in wei) of ETH to send
   -S, --password=<file>      password for non-interactive signing

Options for seth-call(1):

   -B, --block=<number>       block number (default: `latest')
   --hevm                     execute with hevm
   --debug                    execute with hevm interactive mode
   --trace                    dump a trace to stderr
   --code                     overwrite the code of the called contract (hevm only)

Options for seth-send(1):

   --create                   use the calldata to create a new object
   --guess                    guess the return value of the call
   --status                   exit failure on failed tx (Byzantium)
   --resend                   force current nonce to overwrite tx

Options for seth-debug(1):

   --no-src                   don't try to fetch contract source

Options for seth-run-tx(1):

   --debug                    run in hevm interactive mode
   --trace                    dump a trace to stderr
   --source=<file>            path to combined.json source
   --state=<dir>              directory to store hevm state in


Other options:

   --async                    do not wait for transaction receipt
   --follow                   go into a loop watching for new logs
   --json                     print output as JSON (if applicable)

Special commands:

   --from-ascii    convert text data into hexdata
   --from-bin      convert binary data into hexdata
   --from-wei      convert a wei amount into ETH
   --max-int       print the maximum int of the given bits
   --max-uint      print the maximum uint of the given bits
   --min-int       print the minimum int of the given bits
   --to-address    convert hex into checksummed address
   --to-ascii      convert hexdata into text data
   --to-bytes32    convert hexdata into bytes32 value
   --to-dec        convert hex into decimal
   --to-fix        convert wei into fixed point
   --to-hex        convert decimal into hex
   --to-int256     convert an integer into int256 value
   --to-uint256    convert an integer into uint256 value
   --to-wei        convert an ETH amount into wei

Commands:

   age             show the timestamp of the latest block
   balance         show the balance of any account on the blockchain
   block           print a table of information about a specific block
   bundle-source   fetch source and compile contract
   call            call a contract without updating the blockchain
   calldata        pack a signature and a list of arguments into calldata
   chain           print the symbolic name of the current blockchain
   code            print the bytecode of an object on the blockchain
   debug           debug a transaction in hevm interactive
   estimate        estimate how much gas a transaction is likely to use
   etherscan-source  fetch the contract source from etherscan
   events          print the decoded events of some contract
   help            print help about seth(1) or one of its subcommands
   keccak          print the Keccak hash of an arbitrary piece of data
   logs            print the transaction logs of some contract
   ls              display a list of your local accounts and balances (in wei)
   mktx            construct a signed transaction using ethsign
   nonce           show the number of transactions sent from an address
   publish         publish an already-signed transaction to the blockchain
   receipt         wait for a transaction receipt to appear and print it
   run-tx          execute a transaction using hevm
   send            sign and publish a transaction to the blockchain
   sig             print the 4-byte signature of a method
   sign            sign arbitrary data with one of your account keys
   solc            compile a single file using a default --standard-json input
   storage         show the value of a storage slot on the blockchain
   tx              print a table of information about a transaction

Report bugs to <https://github.com/dapphub/dapptools/issues>.
```

## Examples


```
# get next nonce
seth nonce $ETH_FROM

# get the chain name
seth chain

# accounts
seth accounts
seth ls

# send 1 eth to an account
seth send --value $(seth --to-wei 1 eth) 0x0cde80AD77Ab131510036A72b012a4A0F26C2ABB

# send 1 eth to an account [using pipes]
seth --to-wei 0.01 eth | xargs -I{} seth send --value {} 0x0cde80AD77Ab131510036A72b012a4A0F26C2ACC

# get my balance in eth
seth balance $ETH_FROM | seth --from-wei

# call function [write]
export FAUCET=0xe8121d250973229e7988ffa1e9330b420666113a
export COL1=0x911eb92e02477a4e0698790f4d858e09dc39468a
seth send $FAUCET 'gulp(address)' $COL1

# call function [write] with specific nonce
ETH_NONCE=9 seth send $FAUCET 'gulp(address)' $COL1

# call function [write - 2 args]
export TARGET=0x2aAbd7964dE45e6409504038f55D95c28Ff08b99
seth send $TARGET 'setVars(address,uint)' '0x4828699...' '3'

# call function [read]
MKR_TOKEN=0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2
seth call $MKR_TOKEN "totalSupply()(uint)"

# using strings
export RESULT=$(seth calldata "f(string)" '"Hello World"')
seth --calldata-decode "f(string)" $RESULT

# using arrays
export AMOUNT=$(seth --to-wei 5 ether)
export TEST=$(seth calldata "f(uint256[])" "[$AMOUNT]"
seth --calldata-decode "f(uint256[])" $TEST

# create an off-line contract transaction
seth mktx $CONTRACT 'createRandomZombie(string)' 'a1'

# create an off-line ERC20 transaction

# view contract logs
export SETH_ABI=$(seth --decorate-abi $(cat out/ZombieOwnership.abi))
seth events $CONTRACT

# create and sign an off-line transaction and save
seth mktx --value $(seth --to-wei 0.00005 eth) 0x0cde80AD77Ab131510036A72b012a4A0F26C2ACC > tx

# create a QR code and preview
qrencode -m 30 -o tx.png -r ./tx

```



## QR code

Create from file and preview

```
qrencode -m 30 -o q.png -r ./PASS && eog q.png
```

## Nix

* [nix-tour](https://nixcloud.io/tour/?id=1)
* [nix-pils](https://nixos.org/guides/nix-pills/pr01.html)
* [nix-examples](https://medium.com/@MrJamesFisher/nix-by-example-a0063a1a4c55)

