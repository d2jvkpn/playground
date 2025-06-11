#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


WG_IF=wg0
CLIENT_IP=10.0.0.2
SERVER_WG_IP=10.0.0.1
SERVER_PUBLIC="填写上面生成的公钥"
SERVER_ENDPOINT="1.2.3.4:51820"  # 替换为 B 的公网 IP:端口

mkdir -p client-configs
umask 077
wg genkey | tee client_private.key | wg pubkey > client_public.key

CLIENT_PRIVATE=$(cat client_private.key)
CLIENT_PUBLIC=$(cat client_public.key)

echo "📄 生成客户端配置 client-A.conf..."
cat <<EOF > client-configs/client-A.conf
[Interface]
Address = ${CLIENT_IP}/24
PrivateKey = ${CLIENT_PRIVATE}
DNS = 1.1.1.1

[Peer]
PublicKey = ${SERVER_PUBLIC}
Endpoint = ${SERVER_ENDPOINT}
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
EOF

echo ""
echo "✅ 客户端配置已生成：client-configs/client-A.conf"
echo "👇 客户端公钥（请加到服务端的 wg0.conf）："
echo "[Peer]"
echo "PublicKey = ${CLIENT_PUBLIC}"
echo "AllowedIPs = ${CLIENT_IP}/32"
