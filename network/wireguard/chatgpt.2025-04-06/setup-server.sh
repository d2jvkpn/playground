#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


WG_IF=wg0
WG_PORT=51820
WG_NET=10.0.0.0/24
SERVER_IP=10.0.0.1
WG_DIR=/etc/wireguard
PUB_IF=$(ip route get 1 | awk '{print $5; exit}')

echo "🛠️ 安装 WireGuard..."
sudo apt update
sudo apt install -y wireguard qrencode

echo "🔐 生成服务端密钥..."
umask 077
wg genkey | tee server_private.key | wg pubkey > server_public.key

SERVER_PRIVATE=$(cat server_private.key)
SERVER_PUBLIC=$(cat server_public.key)

echo "📦 配置 WireGuard Server..."
cat <<EOF | sudo tee ${WG_DIR}/${WG_IF}.conf
[Interface]
Address = ${SERVER_IP}/24
ListenPort = ${WG_PORT}
PrivateKey = ${SERVER_PRIVATE}
PostUp = iptables -t nat -A POSTROUTING -s ${WG_NET} -o ${PUB_IF} -j MASQUERADE
PostDown = iptables -t nat -D POSTROUTING -s ${WG_NET} -o ${PUB_IF} -j MASQUERADE

EOF

echo "🔓 开启 IP 转发..."
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

echo "🚀 启动 WireGuard 服务..."
sudo systemctl enable wg-quick@${WG_IF}
sudo systemctl start wg-quick@${WG_IF}

echo "✅ 服务器端部署完成！"

echo ""
echo "🎉 请把下面的公钥填入客户端脚本中："
echo "Server Public Key: ${SERVER_PUBLIC}"
