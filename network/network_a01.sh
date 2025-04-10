#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(readlink -f `dirname $0`)

exit

####
ip route show default

dev=$(ip route show default | awk '{print $5}')
ip -4 addr show $dev | awk '/inet/{print $2}'

ip route show default |
  awk '{print $5}' |
  xargs ip addr show |
  awk '/inet /{print $1, $2, $3, $4} /inet6/{print $1, $2}'

####
netstat -ntlp

netstat -ano | grep -w 42221

lsof -i :42221

netstat -anp | grep 42221

####
sudo tcpdump -i any -n port 53

####
dig +short site.domain

dig ns site.domain

####
pip3 install grip

grip docs/api/open/login.md 


####
ss -t
ss -u

ss -tlnp

ss -tunap

ss -tulpn | grep :8080

ss -tan | awk '{print $4}' | cut -d':' -f2 | sort | uniq -c | sort -nr
