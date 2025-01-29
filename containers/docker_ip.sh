#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

exit 0
docker exec <container_id_or_name> sh -c "hostname -I"
docker run --add-host=host.docker.internal:host-gateway ... # windows or mac
docker exec <container_id_or_name> sh -c "ip route | awk '/default/ { print $3 }'"
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' elastic02

exit
cat <<EOF
networks:
  net:
    name: test_network
    driver: bridge
    ipam:
      driver: default
      config:
      - { subnet: 172.16.238.0/24, gateway: 172.16.238.1 }

services:
  web:
    image: nginx:stable-alpine
    container_name: test_nginx
    networks:
      net: { ipv4_address: 172.16.238.10 }

  datanase:
    image: postgres:15-alpine
    container_name: test_postgres
    networks:
      net: { ipv4_address: 172.16.238.11 }
    environment:
    - POSTGRES_user=postgres
    - POSTGRES_PASSWORD=postgres
EOF
