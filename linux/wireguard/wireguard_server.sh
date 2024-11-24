#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# 1. wireguard server
exit
sudo apt update
sudo apt install -y wireguard

umask 077
wg genkey | tee /etc/wireguard/wireguard.key | wg pubkey > /etc/wireguard/wireguard.pub
ls -al /root/apps/wireguard

cat > /etc/wireguard/wg0.conf <<EOF
[Interface] 
PrivateKey = $(cat /etc/wireguard/wireguard.key)
Address = 10.0.0.1/24
ListenPort = 51820

[Peer]
PublicKey = $(cat /etc/wireguard/wireguard.pub)
AllowedIPs = 10.0.0.2/32
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
cat > /etc/sysctl.conf.d/custom.conf <<EOF
net.ipv4.ip_forward=1
EOF

sudo sysctl -p

sudo iptables -A FORWARD -i wg0 -j ACCEPT
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
