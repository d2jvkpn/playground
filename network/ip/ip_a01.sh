#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
ip addr show

ip link show up

ip addr show dev eth0

ip route  show default
