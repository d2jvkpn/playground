#!/usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# sudo apt install -y nmap

dev=$(ip -o -4 route show to default | awk '{print $5}')
host_ip=$(ip -o -4 route show | awk -v dev=$dev '$3==dev{print $1}')

# 192.168.1.42/24
# nmap -sn $host_ip |
#   awk '/Nmap scan report for/{print $NF}' |
#   sed 's/^(//; s/)$//'

nmap --open -p 80,445 $host_ip
