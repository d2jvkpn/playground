#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0)


#### server
./target/server_linux_amd64 --crypt aes --key "your_password" --log logs/kcp_server.log \
  --target 127.0.0.1:22 --listen :29900

#### client
./target/client_linux_amd64 --crypt aes --key "your_password" --log logs/kcp_client.log \
  --remoteaddr ${server_ip}:29900 --localaddr :2022

ssh -p 2022 root@localhost
