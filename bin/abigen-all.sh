#!/usr/bin/env bash

set -eo pipefail

[[ -z "$1" ]] && echo "missing package name" && exit 1

# import the deployment helpers
. $(dirname $0)/common.sh


# name inputs
: ${PACKAGE:=$1}


# TODO: search for contract names in the src folder
declare -a contracts=(inbox message bridge rollup)
for CONTRACT in ${contracts[@]}; do
  abi=$(get_abi $CONTRACT)
  abigen -pkg $PACKAGE --type ${CONTRACT^} --abi <(echo "$abi") --out ./out/$CONTRACT.go
done


