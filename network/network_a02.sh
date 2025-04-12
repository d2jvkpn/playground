#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})


#### block an ip
iptables -I INPUT -s x.x.x.x -j DROP
cat /etc/hosts.deny
netstat -ano | grep 1234


####
netstat -tulpn | grep 5432
netstat -uulpn | grep 5432

net -ano

iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -p tcp --dport 80 -j DROP

iptables -L -v

iptables -t nat -L -n -v | grep 5432
