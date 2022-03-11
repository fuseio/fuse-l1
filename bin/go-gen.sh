#!/usr/bin/env bash



# generate go binding for all ABIs in the output json
generate() {
	NAME=$1

	# find file path
	CONTRACT_PATH=$(find ./src -name $NAME.sol)
	CONTRACT_PATH=${CONTRACT_PATH:2}

	# select the filename and the contract in it
	PATTERN=".contracts[\"$CONTRACT_PATH\"].$NAME"

	# Compile / Build
	#dapp build

  echo "name: $NAME"
  echo "path: $CONTRACT_PATH"
	# get the constructor's signature
	ABI=$(jq -r "$PATTERN.abi" out/dapp.sol.json)
	SIG=$(echo "$ABI" | seth --abi-constructor)


	echo "$ABI"
}


