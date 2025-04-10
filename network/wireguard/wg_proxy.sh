#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


#### 1. enable ip_forward
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

#### 2. allow forwarding
iptables -A FORWARD -i wg0 -j ACCEPT  # up command
#iptables -A FORWARD -s 10.1.1.0/24 -j ACCEPT
#iptables -P FORWARD ACCEPT
#iptables -A FORWARD -i %i -j ACCEPT
#iptables -D FORWARD -i wg0 -j ACCEPT # down command
iptables -L FORWARD -n -v             # check command

# example 01
#iptables -A FORWARD -p tcp --dport 443 -s 10.1.1.0/24 -j ACCEPT
#iptables -t nat -A POSTROUTING -p udp --dport 53 -s 10.1.1.0/24 -o eth0 -j MASQUERADE
# -p tcp / udp / icmp    protocol
# --dport 80             destination port
# -d 8.8.8.8             destination address
# --sport 12345          source port
# -s 10.1.1.0/24         source address
# -i wg0                 input interface
# -o eth0                output interface

# example 02
# iptables -A FORWARD -i wg0 -p tcp --dport 443 -j ACCEPT
# iptables -A FORWARD -i wg0 -p tcp --dport 25 -j DROP


#### 3. set nat masquerading, from 10.1.1.0/24 to eth0
iptables -t nat -A POSTROUTING -s 10.1.1.0/24 -o eth0 -j MASQUERADE  # up command
#iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
#iptables -t nat -D POSTROUTING -s 10.1.1.0/24 -o eth0 -j MASQUERADE # down command
iptables -t nat -L -n -v                                             # check command

#### 4. persiste iptables rules
exit # alternative
apt install iptables-persistent
systemctl status netfilter-persistent

iptables-save > /etc/iptables/rules.v4  # iptables-restore < /etc/iptables/rules.v4
ip6tables-save > /etc/iptables/rules.v6 # ip6tables-restore < /etc/iptables/rules.v6
