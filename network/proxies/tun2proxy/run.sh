#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)

tun2proxy/tun2proxy-bin --setup --proxy=socks5://192.168.1.6:1080 --dns=virtual --bypass=192.168.1.6


echo "/etc/resolv.conf"

cat <<EOF
nameserver 198.18.0.1
options ndots:0
EOF
