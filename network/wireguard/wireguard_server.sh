#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# 1. wireguard server
exit
sudo apt update
sudo apt install -y wireguard

[ -f /usr/local/bin/resolvconf ] &&
  ln -s /usr/bin/resolvectl /usr/local/bin/resolvconf

umask 077
wg genkey | tee /etc/wireguard/wg0.key | wg pubkey > /etc/wireguard/wg0.pub

cat > /etc/wireguard/wg0.conf <<EOF
[Interface]
PrivateKey = $(cat /etc/wireguard/wg0.key)  # 服务器的私钥
Address = 10.0.0.1/24                       # VPN 网络的 IP 地址
ListenPort = 51820                          # 监听的端口

# [Peer]
# PublicKey = client.pub::text  # 客户端的公钥
# AllowedIPs = 0.0.0.0/0      # 允许客户端访问的网络
EOF

wg-quick up wg0

wg show
# wg-quick down wg0
# netstat -alup

# 2. autostart
exit
systemctl enable wg-quick@wg0

# 3. network
exit
# temporary: sysctl -w net.ipv4.ip_forward=1

cat >> /etc/sysctl.conf<<EOF

# custom
net.ipv4.ip_forward=1
EOF

sudo sysctl -p
sysctl net.ipv4.ip_forward
sysctl --system

sudo iptables -A FORWARD -i wg0 -j ACCEPT
sudo iptables -t nat -A POSTROUTING -o wg0 -j MASQUERADE
