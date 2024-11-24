#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

exit
sudo apt intsall wireguard-tools

wg genkey | tee wireguard.key | wg pubkey > wireguard.pub

cat > /etc/wireguard/wg0.conf <<EOF
[Interface]
PrivateKey = $(cat wireguard.key)
Address = 10.0.0.2/24
DNS = 1.1.1.1

[Peer]
PublicKey = <ServerPublicKey>
Endpoint = <ServerIP>:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
EOF

wg-quick up wg0
