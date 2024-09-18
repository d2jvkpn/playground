#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

remote_host=$1
address=${2:-127.0.0.1:1081}

[ ! -z "$(netstat -tulpn 2>/dev/null | grep -w "$address")" ] && {
    >&2 echo '!!!'" address is occupied: $address"
    exit 0
}

>&2 echo "==> socks5 proxy: address=$address, remote_host=$remote_host"

# autossh -f
ssh -NC -D "$address" \
  -o "ServerAliveInterval 5" \
  -o "ServerAliveCountMax 3" \
  -o "ExitOnForwardFailure yes" \
  "$remote_host"

exit
####
chromium --disable-extensions --proxy-server="socks5://127.0.0.1:1081"
firefox -p proxy
