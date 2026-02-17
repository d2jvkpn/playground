#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
#### server
./target/server_linux_amd64 --crypt aes --key "your_password" --log logs/kcp-server.log \
  --target 127.0.0.1:22 --listen :29900

#### client
./target/client_linux_amd64 --crypt aes --key "your_password" --log logs/kcp-client.log \
  --remoteaddr ${server_ip}:29900 --localaddr :2022

ssh -p 2022 root@localhost

ssh -NC -F configs/ssh.conf -D 127.0.0.1:1080 -p 2022 root@localhost


exit
####
target_addr=$1 # 127.0.0.1:22
listen_addr=$2 # :2900

mkdir -p logs

kcptun-server -c configs/kcptun-server.json --target $target_addr --listen $listen_addr


####
remote_addr=$1 # 192.168.1.42:29900
local_addr=$2  # 127.0.0.1:2022

mkdir -p logs

kcptun-client -c configs/kcptun-client.json --remoteaddr $remote_addr --localaddr $local_addr
