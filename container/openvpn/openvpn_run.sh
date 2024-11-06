#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})


vpn_file=${vpn_file:-configs/data.ovpn}
vpn_auth=${vpn_auth:-configs/openvpn.auth}

cd ${_path}

sudo openvpn --config "$vpn_file" --auth-user-pass "$vpn_auth"

exit

cat > configs/openvpn.auth <<EOF
account
password
EOF
