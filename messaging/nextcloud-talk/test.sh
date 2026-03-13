#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


echo https://hub.docker.com/r/nextcloud/all-in-one

mkdir -p data/nextcloud-aio

# For Linux and without a web server or reverse proxy (like Apache, Nginx and else) already in place:
docker run \
  --sig-proxy=false \
  --name nextcloud-aio-mastercontainer \
  --restart always \
  --publish 80:80 \
  --publish 8080:8080 \
  --publish 8443:8443 \
  --env SKIP_DOMAIN_VALIDATION=true \
  --volume nextcloud_aio_mastercontainer:/mnt/docker-aio-config \
  --volume /var/run/docker.sock:/var/run/docker.sock:ro \
  nextcloud/all-in-one:latest

docker exec nextcloud-aio-mastercontainer grep password /mnt/docker-aio-config/data/configuration.json
