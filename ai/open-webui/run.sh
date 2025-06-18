#!//bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


mkdir -p data/open-webui

docker run -d -p 3000:3000 -p 8080:8080 --name open-webui --restart always \
  -v $PWD/data/open-webui:/app/backend/data \
  ghcr.io/open-webui/open-webui:main


cat <<EOF
services:
  alpine:
    image: alpine:3
    container_name: alpine
    extra_hosts:
    - host01:192.168.1.100
    - host02:192.168.1.101
    command: sleep infinity
EOF
