#!/usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

ip route show default

dev=$(ip route show default | awk '{print $5}')
ip -4 addr show $dev | awk '/inet/{print $2}'
