#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# echo "Hello, world!"
ssh -N -L 3336:127.0.0.1:3306 [USER]@[SERVER_IP]


