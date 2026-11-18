#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)


## backup
cp /etc/pf.conf /etc/pf.conf.bk

## create wireguard rules config
cat > /etc/pf.anchors/wireguard <<'EOF'
vpn_ip = "10.1.10.20"
vpn_net = "10.1.10.0/24"
trusted = "10.1.10.10"

# 允许本机主动连接其他 VPN 客户端
pass out quick inet from $vpn_ip to $vpn_net keep state

# 允许白名单客户端主动连接本机
pass in quick inet from $trusted to $vpn_ip keep state

# 拒绝其他 VPN 客户端主动连接本机
block drop in quick inet from $vpn_net to $vpn_ip
EOF

cat >> /etc/pf.conf <<EOF
anchor "wireguard"
load anchor "wireguard" from "/etc/pf.anchors/wireguard"
EOF

## apply
# 启用 PF（尚未启用时）
sudo pfctl -E

# 检查语法 && 加载规则
sudo pfctl -nf /etc/pf.conf
sudo pfctl -f /etc/pf.conf

# 查看 WireGuard 规则
sudo pfctl -a wireguard -sr

sudo pfctl -a wireguard -f /etc/pf.anchors/wireguard

sudo pfctl -sr
sudo pfctl -a wireguard -vvsr
