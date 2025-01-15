#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

exit
#### 1. 
ssh-keygen -R [hostname],[ip_address]
ssh-keyscan -p 22 -H [hostname],[ip_address] >> ~/.ssh/known_hosts

ssh -o ProxyCommand='nc --proxy-type socks4 --proxy 127.0.0.1:9050 %h %p' target@remote

ssh -J account1@remote,account2@remote,account2@remote target@remote

ssh -o ProxyCommand="ssh -W %h:%p account@remmote" target@remote


ssh-keygen -t rsa -b 2048 -m PEM -P "" -C "ubuntu@localhost" -f kvm.pem

ssh-keygen -t rsa -b 4096 -N "" -f id_rsa
ssh-keygen -y -f id_rsa > id_rsa.pub

#  -P "current_passphrase" -N "new_passphrase"
ssh-keygen -t ed25519 -m PEM -N "" -C "ubuntu@localhost" -f host.ssh-ed25519

ssh-keygen -y -f host.pem > host.ssh-ed25519.pub


ssh -o PreferredAuthentications=password -p 22 target@remote

exit
#### 2. ssh tunneling
# 1. access a remote service(postgres) from local
ssh -NC -L 127.0.0.1:5432:127.0.0.1:5432 remote

psql -h 127.0.0.1 -U postgres -p 5432 # local

# 2. reverse(local serivce 8000, remote port 9090)
python3 -m http.server # local

ssh -NC -R 9000:localhost:8000 user@remote-server.com

curl localhost:9000 # remote

# 3. socks5 service
ssh -NC -D 127.0.0.1:1081 remote

curl --connect-timeout 2 -x socks5h://127.0.0.1:1081 https://www.google.com # local
