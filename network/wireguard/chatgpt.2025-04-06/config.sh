#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


wg-quick up wg0
#wg-quick up ./configs/wg0.conf
wg-quick down wg0

wg show all
ip route

sysctl -w net.ipv4.ip_forward=1
#echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
#sudo sysctl -p
cat /proc/sys/net/ipv4/ip_forward


iptables -t nat -L -n
iptables -t nat -L -n -v

dig ifconfig.me

ip route get 1 | awk '{print $5; exit}'

iptables -t nat -A POSTROUTING -s 10.1.1.0/24 -o eth0 -j MASQUERADE
iptables -t nat -D POSTROUTING -s 10.1.1.0/24 -o eth0 -j MASQUERADE



