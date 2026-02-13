#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit

#### 1. create a network with subnet
docker network create \
  --driver bridge \
  --subnet 172.28.0.0/16 \
  --gateway 172.28.0.1 \
  nginx
# --ip-range 172.28.5.0/24

docker network inspect nginx

#### 2. specify ip address of a container in a network
docker run -d --name app \
  --network nginx \
  --ip 172.28.5.10 \
  nginx:1-alpine

cat > compose.yaml <<EOF
networks:
  nginx:
    driver: bridge
    ipam:
      config:
      - subnet: 172.28.0.0/16
        gateway: 172.28.0.1

services:
  app:
    image: nginx:alpine
    networks:
      nginx:
        ipv4_address: 172.28.5.10
EOF
