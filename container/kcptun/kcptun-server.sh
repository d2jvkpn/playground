#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0)

kcptun-server -c configs/kcptun-server.json --target 127.0.0.1:22 --listen :29900
