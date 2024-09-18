#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

port=$1
remote_host=$2

# autossh -f
ssh -NC -D "$port" \
  -o "ServerAliveInterval 5" \
  -o "ServerAliveCountMax 3" \
  -o "ExitOnForwardFailure yes" \
  "$remote_host"

exit

chromium --disable-extensions --proxy-server="socks5://127.0.0.1:1081"

firefox -p proxy
