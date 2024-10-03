#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

function show_help() {
    >&2 echo -e "Usage $(basename $0):\n     socks5_proxy.sh <remote_host> [127.0.0.1:1081]"
}

if [ $# -eq 0 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    show_help
    exit 0
fi

remote_host="$1"
address="${2:-127.0.0.1:1081}"

[ ! -z "$(netstat -tulpn 2>/dev/null | grep -w "$address")" ] && {
    >&2 echo '!!!'" address is occupied: $address"
    exit 0
}

>&2 echo "==> socks5 proxy: remote_host=$remote_host, address=$address"

# autossh -f
# -o "UserKnownHostsFile=~/.ssh/known_hosts"
# -i ~/.ssh/id_rsa
ssh -NC -D "$address" \
  -o "ServerAliveInterval 5" \
  -o "ServerAliveCountMax 3" \
  -o "ExitOnForwardFailure yes" \
  "$remote_host"

exit 0

proxy=socks5://127.0.0.1:1081
# proxy=socks5://username:password@127.0.0.1:1081

https_proxy=$proxy git pull
https_proxy=$proxy curl -4 https://icanhazip.com

# neither firefox or chromium support socks5 with auth
chromium --disable-extensions --incognito --proxy-server="$proxy"

firefox -p proxy
