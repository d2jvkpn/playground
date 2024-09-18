#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

remote_host=$1
port=${2:-1081}

# autossh -f
ssh -NC -D "$port" \
  -o "ServerAliveInterval 5" \
  -o "ServerAliveCountMax 3" \
  -o "ExitOnForwardFailure yes" \
  "$remote_host"

exit
####
chromium --disable-extensions --proxy-server="socks5://127.0.0.1:1081"
firefox -p proxy
