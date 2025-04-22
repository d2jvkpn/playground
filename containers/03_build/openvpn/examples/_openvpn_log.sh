#!/bin/bash
set -e

# server.conf: client-disconnect /etc/openvpn/scripts/on_client_disconnect.sh
LOGFILE="/var/log/openvpn-client.log"

echo "$(date +'%Y-%m-%d %H:%M:%S'),$common_name,$trusted_ip,$trusted_port,$ifconfig_pool_remote_ip" >> "$LOGFILE"

echo "[$(date)] client $common_name from $trusted_ip:$trusted_port connected." >> "$LOGFILE"
echo "Assigned VPN IP: $ifconfig_pool_remote_ip" >> "$LOGFILE"

# 例如：按 CN 指定静态路由配置
if [ "$common_name" = "special_user" ]; then
  echo 'push "route 192.168.100.0 255.255.255.0"' > "$1"
fi

exit 0


#### server.conf: client-disconnect /etc/openvpn/scripts/on_client_disconnect.sh
LOGFILE="/var/log/openvpn-client-disconnect.log"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Client '$common_name' disconnected from $trusted_ip:$trusted_port (VPN IP: $ifconfig_pool_remote_ip)" >> "$LOGFILE"
