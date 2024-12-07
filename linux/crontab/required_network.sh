#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

while ! ping -c 1 -W 1 8.8.8.8; do
   echo "等待网络就绪..."
   sleep 5
done


echo TODO
