#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})


vpn_file=${1:-configs/openvpn.ovpn}
vpn_acc=${2:-configs/openvpn.pass}
relative=${relative:-false}

[[ "$relative" == "true" ]] && cd "${_path}"

if [[ "$vpn_acc" == *".pass" ]]; then
    sudo openvpn --config "$vpn_file" --askpass "$vpn_acc"
else
    sudo openvpn --config "$vpn_file" --auth-user-pass "$vpn_acc"
fi

####
exit

cat > configs/openvpn.pass <<EOF
password
EOF

cat > configs/openvpn.auth <<EOF
account
password
EOF
