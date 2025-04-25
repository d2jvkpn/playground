#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


table=${table:-"auto"}
vpn_file=${1:-configs/client.ovpn}
vpn_pass=${2:-configs/client.ovpn.pass}


[[ ! -s "$vpn_file" || ! -s "$vpn_pass" ]] && { >&2 echo '!!! config files not exists' ; exit 1; }

vpn_server=$(awk '$1=="remote"{print $2":"$3}' $vpn_file)
echo "==> $(date +%FT%T%:z) Connecting to vpn: $vpn_server"

#--route-noexec: Don't add or remove routes automatically. Instead pass routes to --route-up script using environmental
#  variables.
#--route-nopull: When used with --client or --pull, accept options pushed by server EXCEPT for routes, 
#  block-outside-dns and dhcp options like DNS servers.When used on the client, this option effectively bars the server
#  from adding routes to the client's routing table, however note that this option still allows the server to set the
#  TCP/IP properties of the client's TUN/TAP interface.
vpn_args="--auth-nocache"
if [[ "$table" == "off" ]]; then
    vpn_args="$vpn_args --route-noexec --route-nopull"
fi

if [[ "$vpn_pass" == *".pass" ]]; then
    sudo openvpn $vpn_args --config "$vpn_file" --askpass "$vpn_pass"
else
    sudo openvpn $vpn_args --config "$vpn_file" --auth-user-pass "$vpn_pass"
fi

####
exit

cat > configs/client.ovpn.pass <<EOF
${password}
EOF

cat > configs/client.ovpn.auth <<EOF
${account}
${password}
EOF
