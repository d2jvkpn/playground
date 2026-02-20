#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
wget -O hysteria https://github.com/apernet/hysteria/releases/latest/download/hysteria-linux-amd64
chmod a+x hysteria

exit
mkdir -p configs

openssl req -x509 -nodes -newkey rsa:2048 \
  -keyout configs/server.key \
  -out configs/server.crt \
  -days 3650 \
  -subj "/CN=bing.com"

password=$(tr -dc 'a-zA-Z0-9' < /dev/random  | fold -w 32 | head -n 1 || true)

exit
./hysteria server -c configs/hysteria.server.yaml
./hysteria client -c configs/hysteria.client.yaml

exit
tcpdump -i eth0 udp port 443
