#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


function display_usage() {
cat <<'EOF'
# Usage of ssh-socks5

#### 1. Run
ssh-socks5.sh <remote_host> [127.0.0.1:1081]

#### 2. Environment variables
config=""

#### 3. SSH config
```conf
Host remote_host
    ProxyJump host1,host2
    ProxyCommand  nc -X 5 -x 127.0.0.1:1090 %h %p
    HostName 127.0.0.1
    User account
    Port 22
    IdentityFile ~/.ssh/id_rsa
    UserKnownHostsFile ~/.ssh/known_hosts
    Compression yes
    LogLevel INFO
    ServerAliveInterval 5
    ServerAliveCountMax 3
    ExitOnForwardFailure yes
```

#### 4. Examples
https_proxy=socks5h://127.0.0.1:1081 git pull

https_proxy=socks5h://127.0.0.1:1081 curl https://icanhazip.com

curl -x socks5h://127.0.0.1:1081 https://icanhazip.com

# neither firefox or chromium support socks5 with auth
chromium --disable-extensions --incognito --proxy-server=socks5h://127.0.0.1:1081

firefox -p proxy

https_proxy=socks5h://127.0.0.1:1081 remmina
EOF
}

case "${1:-""}" in
"" | "help" | "-h" | "--help")
    display_usage
    exit 0
    ;;
esac

remote_host="$1"
address="${2:-127.0.0.1:1081}"
config=${config:-""}

[ ! -z "$(netstat -tulpn 2>/dev/null | grep -w "$address")" ] && {
    >&2 echo '!!!'" address is occupied: $address"
    exit 1
}

# autossh -f -p 22 -i ~/.ssh/id_rsa -o "UserKnownHostsFile=~/.ssh/known_hosts"
if [ ! -z "$config" ]; then
    set -x
    ssh -NC -F "$config" -D "$address" "$remote_host"
else
    set -x
    ssh -NC -D "$address" \
      -o ServerAliveInterval=5 \
      -o ServerAliveCountMax=3 \
      -o ExitOnForwardFailure=yes \
      "$remote_host"
fi
