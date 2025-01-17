#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

docker pull portainer/portainer-ce

docker volume create portainer

docker run -d --name=portainer --restart=always \
  -p 8000:8000 -p 9000:9000 \
  -v /var/run/docker.sock:/var/run/docker.sock -v portainer:/data \
  portainer/portainer-ce

curl localhost:9000
