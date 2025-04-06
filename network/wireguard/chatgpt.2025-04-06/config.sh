#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


wg show all

ip route

cat /proc/sys/net/ipv4/ip_forward

iptables -t nat -L -n

dig ifconfig.me
