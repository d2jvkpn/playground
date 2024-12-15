#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0)


remote_addr=$1 # 192.168.1.42:29900
local_addr=$2  # 127.0.0.1:2022

mkdir -p logs

kcptun-client -c configs/kcptun-client.json --remoteaddr $remote_addr --localaddr $local_addr

exit

mkdir -p configs

cat > configs/kcptun-client.json <<EOF
{
  "crypt": "aes",
  "mode": "fast3",
  "nocomp": true,
  "autoexpire": 900,
  "sockbuf": 16777217,
  "dscp": 46,
  "log": "logs/kcptun-client.log",
  "key": "your_password"
}
EOF
