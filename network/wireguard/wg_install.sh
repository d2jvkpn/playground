#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit

#### 1. wireguard server
sudo apt update
sudo apt install -y wireguard wireguard-tools

[ -f /usr/local/bin/resolvconf ] &&
  ln -s /usr/bin/resolvectl /usr/local/bin/resolvconf

umask 077
# wg genkey | tee /etc/wireguard/wg0.key | wg pubkey > /etc/wireguard/wg0.pub
wg_key=$(wg genkey)
wg_pub=$(echo $wg_key | wg pubkey)

cat > /etc/wireguard/wireguard.yaml <<EOF
wg0:
  key: $wg_key
  pub: $wg_pub
EOF


#### 2. configs
echo "==> wg lan network"
ls examples/wg-lan.client.conf examples/wg-lan.server.conf

echo "==> wg proxy"
ls examples/wg-proxy.client.conf examples/wg-proxy.server.conf

#### 3. services
wg show all
wg show wg0
wg showconf wg0
wg show all dump

wg-quick up wg0
wg-quick down wg0

wg syncconf wg0 <(wg-quick strip wg0)
wg syncconf wg0 <(wg-quick strip /etc/wireguard/wg0)

netstat -ulnp

systemctl enable wg-quick@wg0
journalctl -u wg-quick@wg0

dmesg | grep wireguard


#### ?? 4. route
cat > /etc/iproute2/rt_tables <<EOF
200     wireguard
EOF

WG_INTERFACE=wg0

sudo ip rule add from <LOCAL_IP_RANGE> table wireguard
sudo ip rule add to <TARGET_IP_RANGE> table wireguard

sudo ip route add default dev $WG_INTERFACE table wireguard
