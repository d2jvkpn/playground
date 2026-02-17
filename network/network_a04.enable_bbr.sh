#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


mv /etc/sysctl.conf /etc/sysctl.conf.bk
cp /etc/sysctl.conf.bk /etc/sysctl.conf

echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p

sysctl net.ipv4.tcp_congestion_control
