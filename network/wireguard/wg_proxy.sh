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

#### 3. set nat masquerading, from 10.1.1.0/24 to eth0
iptables -t nat -A POSTROUTING -s 10.1.1.0/24 -o eth0 -j MASQUERADE  # up command
#iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
#iptables -t nat -D POSTROUTING -s 10.1.1.0/24 -o eth0 -j MASQUERADE # down command
iptables -t nat -L -n -v                                             # check command

#### 4. persiste iptables rules
exit
apt install iptables-persistent
systemctl status netfilter-persistent

iptables-save > /etc/iptables/rules.v4  # iptables-restore < /etc/iptables/rules.v4
ip6tables-save > /etc/iptables/rules.v6 # ip6tables-restore < /etc/iptables/rules.v6

### 5. debug
exit
##### client
curl -4 https://icanhazip.com
curl -4 -v https://ifconfig.me

curl --interface wg0 https://ifconfig.me

nslookup ifconfig.me # dig ifconfig.me
ping 1.1.1.1         # ping 8.8.8,8 # ping ifconfig.me

tcpdump -i wg0
iptables -nvL
traceroute 1.1.1.1

#### server
iptables -L -n -v | grep DROP
