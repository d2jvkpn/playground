#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})


vpn_file=${1:-configs/client.ovpn}
vpn_pass=${2:-configs/client.ovpn.pass}

[[ ! -s "$vpn_file" || ! -s "$vpn_pass" ]] && { >&2 echo '!!! config files not exists' ; exit 1; }

vpn_server=$(awk '$1=="remote"{print $2":"$3}' $vpn_file)
echo "==> $(date +%FT%T%:z) Connecting to vpn: $vpn_server"

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
