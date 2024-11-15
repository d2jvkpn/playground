#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

pip3 install runlike
pip3 install whaler

docker ps | awk 'NR>1{print $NF}' | xargs -i runlike {}
