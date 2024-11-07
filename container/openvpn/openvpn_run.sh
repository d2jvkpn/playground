#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})


vpn_file=${1:-configs/openvpn.ovpn}
vpn_auth=${2:-configs/openvpn.pass}
goto=${goto:-false}

[[ "$goto" == "true" ]] && cd "${_path}"

if [[ "$a" == *".pass" ]]; then
    sudo openvpn --config "$vpn_file" --askpass "$vpn_auth"
else
    sudo openvpn --config "$vpn_file" --auth-user-pass "$vpn_auth"
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
