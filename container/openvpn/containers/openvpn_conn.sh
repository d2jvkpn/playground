#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})


vpn_file=${1:-configs/client.ovpn}
vpn_pass=${2:-configs/client.ovpn.pass}
relative=${relative:-false}

[[ "$relative" == "true" ]] && cd "${_path}"

if [[ "$vpn_pass" == *".pass" ]]; then
    sudo openvpn --config "$vpn_file" --auth-nocache --askpass "$vpn_pass"
else
    sudo openvpn --config "$vpn_file" --auth-nocache --auth-user-pass "$vpn_pass"
fi

####
exit

cat > configs/client.ovpn.pass <<EOF
password
EOF

cat > configs/client.ovpn.auth <<EOF
account
password
EOF
