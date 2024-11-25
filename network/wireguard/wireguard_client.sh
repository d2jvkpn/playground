#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

exit
sudo apt intsall wireguard-tools

[ -f /usr/local/bin/resolvconf ] &&
  ln -s /usr/bin/resolvectl /usr/local/bin/resolvconf

wg genkey | tee /etc/wireguard/wg0.key | wg pubkey > /etc/wireguard/wg0.pub

ServerPort=${ServerPort:-51820}

cat > /etc/wireguard/wg0.conf <<EOF
[Interface]
PrivateKey = $(cat /etc/wireguard/wg0.key)
Address = 10.0.0.2/24    # 客户端在 VPN 网络中的 IP 地址
ListenPort = 51820
DNS = 8.8.8.8 # 1.1.1.1

[Peer]
PublicKey = $ServerPublicKey     # 服务端的公钥
Endpoint = $ServerIP:$ServerPort # 服务端的地址
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
EOF

wg-quick up wg0
