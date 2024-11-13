#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

ssh-keygen -R [hostname],[ip_address]
ssh-keyscan -p 22 -H [hostname],[ip_address] >> ~/.ssh/known_hosts

ssh -o ProxyCommand='nc --proxy-type socks4 --proxy 127.0.0.1:9050 %h %p' target@remote

ssh -J account1@remote,account2@remote,account2@remote target@remote

ssh -o ProxyCommand="ssh -W %h:%p account@remmote" target@remote


ssh-keygen -t rsa -b 2048 -m PEM -P "" -C "ubuntu@localhost" -f kvm.pem

ssh-keygen -t rsa -b 4096 -N "" -f id_rsa
ssh-keygen -y -f id_rsa > id_rsa.pub

#  -P "current_passphrase" -N "new_passphrase"
ssh-keygen -t ed25519 -m PEM -N "" -C "ubuntu@localhost" -f host.pem

ssh-keygen -y -f host.pem > host.pem.pub


ssh -o PreferredAuthentications=password -p 22 target@remote
