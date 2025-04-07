#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


#### 1. ip_forward
sysctl -w net.ipv4.ip_forward=1 # temporary

# permanently
cat >> /etc/sysctl.conf<<EOF
net.ipv4.ip_forward=1
EOF

sysctl -p

# check
cat /proc/sys/net/ipv4/ip_forward # expect 1
sysctl net.ipv4.ip_forward        # expect net.ipv4.ip_forward = 1
# sysctl --system

#### 2. 
iptables -A FORWARD -i wg0 -j ACCEPT # up command
#iptables -P FORWARD ACCEPT
#iptables -A FORWARD -i %i -j ACCEPT
#iptables -D FORWARD -i wg0 -j ACCEPT # down command

iptables -L FORWARD -n -v # check

#### 3. 
iptables -t nat -A POSTROUTING -s 192.168.255.0/24 -o eth0 -j MASQUERADE # up command
#iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
#iptables -t nat -D POSTROUTING -s 192.168.255.0/24 -o eth0 -j MASQUERADE # down command

iptables -t nat -L -n -v  # check
