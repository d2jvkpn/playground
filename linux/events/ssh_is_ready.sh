#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

target=$1 # remote_host, -p 2048 remote_host
retries=${2:-300}

n=1
# while ! ansible $target --one-line -m ping; do
while ! ssh -o StrictHostKeyChecking=no $target exit; do
    sleep 1

    n=$((n+1))
    [[ $retries -gt 0 && $n -gt "$retries" ]] && { >&2 echo "ssh can't access: $target"; exit 1; }
done
