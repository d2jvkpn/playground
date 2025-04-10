#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

exit

### 1. debug

##### client
curl -4 https://icanhazip.com
curl -4 -v https://ifconfig.me

curl --interface wg0 https://ifconfig.me

dig ifconfig.me  # nslookup ifconfig.me
ping 1.1.1.1     # ping 8.8.8,8 # ping ifconfig.me
traceroute 1.1.1.1

tcpdump -i wg0
iptables -nvL

#### server
iptables -L -n -v | grep DROP


#### 2. VPN 中转
# 自动 failover, WireGuard + Linux 路由策略 + failover fallback, WireGuard 拓扑：Hub-and-Spoke + Peer Relay
# A(10.1.1.1), B(10.1.1.2), C(10.1.1.3)
# routes: A->B, A->C, C->B
# WireGuard + Linux routing + failover fallback: A -> B -> C

# on A, config
cat <<EOF
[Interface]
Address = 10.1.1.1/24
PrivateKey = <A-Key>

# Peer C
[Peer]
PublicKey = <C-Pub>
Endpoint = <C-PubIP>:51820
AllowedIPs = 10.1.1.3/32
PersistentKeepalive = 25

# Peer B
[Peer]
PublicKey = <B-Pub>
Endpoint = <B-PubIP>:51820
AllowedIPs = 10.1.1.2/32, 10.1.1.2/32
PersistentKeepalive = 25
EOF

# on B, iptables
iptables -A FORWARD -i wg0 -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.1.1.1 -d 10.1.1.3 -j MASQUERADE


#### 3. 阻止访问
# A=10.10.0.1, B=10.10.0.2, interface=wg0

# 允许所有已建立连接的返回流量
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# @A, 拒绝 B 对 A 的访问, 但是运行 A 访问 B
# iptables -A INPUT -i wg0 -s 10.10.0.2 -j DROP 这个会导致 A 不能访问 B, 即 B 的响应被 drop
iptables -A INPUT -i wg0 -s 10.10.0.2 -m conntrack --ctstate NEW -j DROP

# @A, 拒绝 B 访问 A 的 tcp/22 端口
iptables -A INPUT -i wg0 -s 10.10.0.2 -p tcp --dport 22 -j DROP


# 允许 A 自己访问自己
iptables -A INPUT -i wg0 -s 10.10.0.1 -d 10.10.0.1 -j ACCEPT
iptables -A INPUT -i wg0 -d 10.10.0.1 -p udp --dport 53 -j ACCEPT

# 阻止其他任何 peer 访问 A 的 wg IP
iptables -A INPUT -i wg0 -d 10.1.1.100 -m conntrack --ctstate NEW -j DROP
