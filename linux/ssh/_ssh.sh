#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

ssh-keygen -R [hostname],[ip_address]
ssh-keyscan -p 22 -H [hostname],[ip_address] >> ~/.ssh/known_hosts

ssh -o ProxyCommand='nc --proxy-type socks4 --proxy 127.0.0.1:9050 %h %p' target@remote

ssh -J account1@remote,account2@remote,account2@remote target@remote

ssh -o ProxyCommand="ssh -W %h:%p account@remmote" target@remote
