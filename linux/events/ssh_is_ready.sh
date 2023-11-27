#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

target=$1 # remote_host, -p 2048 remote_host
timeout_secs=${2:-0}

n=1
# while ! ansible $target --one-line -m ping; do
while ! ssh -o StrictHostKeyChecking=no $target exit; do
    sleep 1

    n=$((n+1))
    if [[ "$timeout_secs" -gt 0 && $n -gt "$timeout_secs" ]]; then
        >&2 echo "can't access node $target"
        exit 1
    fi
done
