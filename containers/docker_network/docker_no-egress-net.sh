#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

subnet="172.30.0.0/24"
docker network create --subnet $subnet no-egress-net

docker run -d --name app --network no-egress-net -p 8080:80 nginx

sudo iptables -I DOCKER-USER 1 -s $subnet -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A DOCKER-USER -s $subnet -j REJECT

exit
cat <<EOF
services:
  app:
    image: nginx
    networks: [no-egress]
    ports: ["8080:80"]

networks:
  no-egress:
    driver: bridge
    ipam:
      config:
      - subnet: 172.30.0.0/24
EOF

exit
# alternative solution: inside container
docker run -d --name app --cap-add NET_ADMIN -p 8080:80 nginx

iptables -P OUTPUT DROP
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
