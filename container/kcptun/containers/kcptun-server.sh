#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0)


target_addr=$1 # 127.0.0.1:22
listen_addr=$2 # :2900

mkdir -p logs

kcptun-server -c configs/kcptun-server.json --target $target_addr --listen $listen_addr

exit

mkdir -p configs

cat > configs/kcptun-server.json <<EOF
{
  "crypt": "aes",
  "mode": "fast3",
  "nocomp": true,
  "sockbuf": 16777217,
  "dscp": 46,
  "log": "logs/kcptun-server.log",
  "key": "your_password"
}
EOF
