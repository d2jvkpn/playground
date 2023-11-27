#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

node=$1; state=$2; timeout_secs=${3:-0}

echo "==> virsh_wait_until parameters: node=$node, state=\"$state\""

n=1
while [[ "$(virsh domstate --domain "$node" | awk 'NR==1{print $0; exit}')" != "$state" ]]; do
    echo -n "."; sleep 1

    n=$((n+1))
    if [[ "$timeout_secs" -gt 0 && $n -gt "$timeout_secs" ]]; then
        >&2 echo 'virsh_wait_until abort'
        exit 1
    fi
done
echo ""

echo "==> virsh_wait_until successed: node=$node, state=\"$state\""
