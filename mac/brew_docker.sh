#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)


brew install docker docker-compose colima
colima start

mkdir -p ~/.docker/cli-plugins
ln -sfn $(brew --prefix)/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose

exit
colima stop

colima start \
  --network-address \
  --cpu 4 --memory 8 --disk 100 \
  --env HTTP_PROXY=http://127.0.0.1:1080 \
  --env HTTPS_PROXY=http://127.0.0.1:1080 \
  --env NO_PROXY=localhost,127.0.0.1,192.168.0.0/16

brew services start colima

exit
docker version
docker run hello-world

cat ~/Library/LaunchAgents/sh.brew.colima.plist
