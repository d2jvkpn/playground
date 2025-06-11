#!//bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


# 配置参数（可以改成你自己的）
WG_INTERFACE="wg0"
WG_IPV4="10.1.1.1/24"
WG_IPV6="fd42:42:42::1/64"
WG_PORT=51820
WG_CONF="/etc/wireguard/${WG_INTERFACE}.conf"

# 生成密钥
PRIVATE_KEY=$(wg genkey)
echo "$PRIVATE_KEY" > /tmp/server_private.key
PUBLIC_KEY=$(echo "$PRIVATE_KEY" | wg pubkey)

echo "🛠️ Generating WireGuard config with IPv6 support..."

# 写入配置
cat <<EOF | sudo tee "$WG_CONF" > /dev/null
[Interface]
Address = ${WG_IPV4}, ${WG_IPV6}
ListenPort = ${WG_PORT}
PrivateKey = ${PRIVATE_KEY}

# IPv4 防火墙转发规则（如需公网出流量）
PostUp = sysctl -w net.ipv4.ip_forward=1; \
         sysctl -w net.ipv6.conf.all.forwarding=1; \
         iptables -A FORWARD -i ${WG_INTERFACE} -j ACCEPT; \
         iptables -A FORWARD -o ${WG_INTERFACE} -j ACCEPT; \
         ip6tables -A FORWARD -i ${WG_INTERFACE} -j ACCEPT; \
         ip6tables -A FORWARD -o ${WG_INTERFACE} -j ACCEPT

PostDown = iptables -D FORWARD -i ${WG_INTERFACE} -j ACCEPT; \
           iptables -D FORWARD -o ${WG_INTERFACE} -j ACCEPT; \
           ip6tables -D FORWARD -i ${WG_INTERFACE} -j ACCEPT; \
           ip6tables -D FORWARD -o ${WG_INTERFACE} -j ACCEPT
EOF

echo "✅ Config generated at: $WG_CONF"
echo "🔑 Server public key:"
echo "$PUBLIC_KEY"
