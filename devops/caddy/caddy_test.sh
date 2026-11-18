#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)



docker run --rm -v $PWD/configs/Caddyfile:/etc/caddy/Caddyfile \
   q.local/caddy:2 caddy validate --config /etc/caddy/Caddyfile

docker exec -it caddy caddy validate --config /etc/caddy/Caddyfile
docker exec -it caddy caddy reload --config /etc/caddy/Caddyfile

docker logs caddy --tail 100
