#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


cat > /etc/iproute2/rt_tables <<EOF
200     wireguard
EOF


WG_INTERFACE=wg0

sudo ip rule add from <LOCAL_IP_RANGE> table wireguard
sudo ip rule add to <TARGET_IP_RANGE> table wireguard

sudo ip route add default dev $WG_INTERFACE table wireguard
