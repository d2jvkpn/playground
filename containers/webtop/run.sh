#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


docker pull linuxserver/webtop:ubuntu-xfce

exit

docker run -d \
  --name webtop-ubuntu-xfce \
  -p 3000:3000 \
  -p 3001:3001 \
  --shm-size="1gb" \
  -e PIXELFLUX_WAYLAND=true \
  linuxserver/webtop:ubuntu-xfce
