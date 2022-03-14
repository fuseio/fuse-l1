#!/usr/bin/env bash

set -eo pipefail


[[ -z "$1" ]] && echo "missing contract name" && exit 1
[[ -z "$2" ]] && echo "missing package name" && exit 1


# import the deployment helpers
. $(dirname $0)/common.sh


# name inputs
: ${CONTRACT:=$1}
: ${PACKAGE:=$2}

echo "Getting ABI from output json file"
abi=$(get_abi $CONTRACT)
echo $abi


# create go bindings
# we uppercase the contract name to create the type
echo "Generating $CONTRACT go bindings"
abigen -pkg $PACKAGE --type ${CONTRACT^} --abi <(echo "$abi") --out ./out/$CONTRACT.go
