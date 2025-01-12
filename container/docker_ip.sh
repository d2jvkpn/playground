#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

exit 0
docker exec <container_id_or_name> sh -c "hostname -I"
docker run --add-host=host.docker.internal:host-gateway ... # windows or mac
docker exec <container_id_or_name> sh -c "ip route | awk '/default/ { print $3 }'"
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' elastic02
