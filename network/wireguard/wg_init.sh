#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


if [ ! command wg ]; then
    apt update
    apt install -y wireguard wireguard-tools
fi

wg_key=$(wg genkey)
wg_pub=$(echo $wg_key | wg pubkey)

cd /etc/wireguard/
# ls /usr/local/etc/wireguard/ /opt/homebrew/etc/wireguard/

cat > wireguard.yaml <<EOF
wg0:
  key: $wg_key
  pub: $wg_pub
EOF

ls -al wireguard.yaml

cat > wg0.conf <<EOF
[Interface]
PrivateKey = $wg_key
Address = <ip>/24
ListenPort = <port>
#Table = off
#PostUp = echo TODO
#PostDown = echo TODO

[Peer]
PublicKey = <node_pubkey>
AllowedIPs = <node_ip>/32
EOF

ls -al wg0.conf
