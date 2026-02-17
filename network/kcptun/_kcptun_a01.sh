#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


# https://github.com/xtaci/kcptun/releases
mkidr -p target

wget -P target https://github.com/xtaci/kcptun/releases/download/v20241119/kcptun-linux-amd64-20241119.tar.gz

tar -xf target/kcptun-linux-amd64-20241119.tar.gz -C target

#### server
./target/server_linux_amd64 -mode fast3 -nocomp -sockbuf 16777217 -dscp 46 \
  --target "localhost:8000" --listen ":4000"

python3 -m http.server 8000

#### client
./target/client_linux_amd64 -mode fast3 -nocomp -autoexpire 900 -sockbuf 16777217 -dscp 46 \
  --remoteaddr "localhost:4000" --localaddr ":8001"

curl localhost:8001
