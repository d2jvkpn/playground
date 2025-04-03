#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

exit
sudo apt intsall wireguard-tools

[ -f /usr/local/bin/resolvconf ] &&
  ln -s /usr/bin/resolvectl /usr/local/bin/resolvconf

wg genkey | tee /etc/wireguard/wg0.key | wg pubkey > /etc/wireguard/wg0.pub

cat > /etc/wireguard/wg0.conf <<EOF
[Interface]
PrivateKey = oK56DE9Ue9zK76rAc8pBl6opph+1v36lm7cXXsQKrQM=
Address = 10.0.0.2/24    # address in wg0
ListenPort = 51820
Table = off
DNS = 8.8.8.8 # 1.1.1.1

[Peer]
PublicKey = GtL7fZc/bLnqZldpVofMCD6hDjrK28SsdLxevJ+qtKU=  # serevr public key
Endpoint = demo.wireguard.com:51820                       # server address
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
EOF

wg-quick up wg0
