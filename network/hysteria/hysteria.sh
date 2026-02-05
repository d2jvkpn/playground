#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
wget https://github.com/apernet/hysteria/releases/latest/download/hysteria-linux-amd64

mkdir -p bin
mv hysteria-linux-amd64 bin/hysteria
chmod a+x bin/hysteria

mkdir -p configs

openssl req -x509 -nodes -newkey rsa:2048 \
  -keyout configs/server.key \
  -out configs/server.crt \
  -days 3650 \
  -subj "/CN=bing.com"

password=$(tr -dc 'a-zA-Z0-9' < /dev/random  | fold -w 32 | head -n 1 || true)

cat > configs/hysteria.server.yaml <<EOF
listen: :443

tls:
  cert: configs/server.crt
  key: configs/server.key

auth:
  type: password
  password: $password

bandwidth:
  up: 200 mbps
  down: 200 mbps

masquerade:
  type: proxy
  proxy:
    url: https://www.cloudflare.com
    rewriteHost: true
EOF

hysteria server -c configs/hysteria.server.yaml


exit
cat > configs/hysteria.client.yaml <<EOF
server: your.server.ip:443

auth: $password

tls:
  insecure: true

bandwidth:
  up: 100 mbps
  down: 100 mbps

socks5:
  listen: 127.0.0.1:1080

#http:
#  listen: 127.0.0.1:8080

transport:
  udp:
    hopInterval: 30s
EOF


bin/hysteria client -c configs/hysteria.client.yaml
