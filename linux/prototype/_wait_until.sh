#!/usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

node=$1; state=$2
echo "==> vm_state_until: $node, $state"

while [[ "$(virsh domstate --domain "$node" | awk 'NR==1{print $0; exit}')" != "$state" ]]; do
    echo -n "."; sleep 1
done
echo ""

echo "==> successed: $node"
