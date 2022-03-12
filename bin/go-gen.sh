#!/usr/bin/env bash

set -eo pipefail

# import the deployment helpers
. $(dirname $0)/common.sh

# Contract will be counter unless overriden on the command line
: ${CONTRACT:=$1}
echo "Generating $CONTRACT to $NETWORK with arguments: $arguments"
generate $CONTRACT
log "$CONTRACT generated at:" $Addr



