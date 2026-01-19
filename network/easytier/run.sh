#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit

mkdir configs

secret=$(tr -dc "0-9A-Za0z" < /dev/urandom | fold -w 32 | head -n 1 || true)

cat > configs/easytier.yaml <<EOF
network_name: prod-net
network_secret: $secret

ipv4: 10.99.0.10/16
device_name: et0

p2p:
  enable: true

relay:
  enable: true
  public: true
EOF

docker run -d \
  --name easytier \
  --cap-add NET_ADMIN \
  --device /dev/net/tun \
  --network host \
  -v $PWD/configs:/app/configs \
  easytier/easytier:v2.5.0 \
  --config /app/configs/config.yaml

exit
easytier peers

ip route | grep et0

sudo iptables -L -n
sudo nft list ruleset

ip link set et0 mtu 1400

