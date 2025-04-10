#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


ip -6 route

ip6tables -t nat -A POSTROUTING -s fd42:42:42::/64 -o eth0 -j MASQUERADE
