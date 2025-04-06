#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

# 1. wireguard server
exit
sudo apt update
sudo apt install -y wireguard wireguard-tools

[ -f /usr/local/bin/resolvconf ] &&
  ln -s /usr/bin/resolvectl /usr/local/bin/resolvconf

umask 077
wg genkey | tee /etc/wireguard/wg0.key | wg pubkey > /etc/wireguard/wg0.pub

cat > /etc/wireguard/wg0.conf <<EOF
[Interface]
PrivateKey = oK56DE9Ue9zK76rAc8pBl6opph+1v36lm7cXXsQKrQM=  # server private key
Address = 10.0.0.1/24                                      # server ip addres in wg0
ListenPort = 51820                                         # listening port
Table = off
#Table = 1234
#PostUp = ip rule add ipproto tcp dport 22 table 1234
#PreDown = ip rule delete ipproto tcp dport 22 table 1234

#PostUp = iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o eth0 -j MASQUERADE
#PostDown = iptables -t nat -D POSTROUTING -s 10.0.0.0/24 -o eth0 -j MASQUERADE


[Peer]
PublicKey = GtL7fZc/bLnqZldpVofMCD6hDjrK28SsdLxevJ+qtKU=  # client public key
AllowedIPs = 10.0.0.2/24                                  # fixed client ip
EOF

wg-quick up wg0

wg show all
wg show wg0

# wg-quick down wg0
# netstat -alup

# 2. autostart
exit
systemctl enable wg-quick@wg0
journalctl -u wg-quick@wg0
dmesg | grep wireguard

# 3. network
exit
# temporary: sysctl -w net.ipv4.ip_forward=1

cat >> /etc/sysctl.conf<<EOF
net.ipv4.ip_forward=1
EOF

sudo sysctl -p
sysctl net.ipv4.ip_forward
sysctl --system

sudo iptables -A FORWARD -i wg0 -j ACCEPT
sudo iptables -t nat -A POSTROUTING -o wg0 -j MASQUERADE

# 2025-04-06
sudo wg
ip route
cat /proc/sys/net/ipv4/ip_forward
iptables -t nat -L -n
dig ifconfig.me
