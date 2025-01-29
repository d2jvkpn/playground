#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0) # set -x


device=$(ip route | awk '/^default/{print $5}')

docker network create -d macvlan \
  --subnet=192.168.1.0/24 \
  --gateway=192.168.1.1 \
  -o parent=$device macvlan

docker run --network=macvlan --name http-server -d python:3-alpine python3 -m http.server 8000

exit
ip link add macvlan0 link $device type macvlan mode bridge
ip addr add 192.168.1.10/24 dev macvlan0
ip link set macvlan0 up
