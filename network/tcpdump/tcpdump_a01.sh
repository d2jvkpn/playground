#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
iptables -n -v -L

tcpdump -i eth0 udp port 443 -s 0

tcpdump -i eth0 udp port 443 -s 0 -w test.cap
tcpdump -r test.cap

tcpdump -n -i any udp port 443 -vv
