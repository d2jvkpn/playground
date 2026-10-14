#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)


# 192.168.1.12:1080 -> 192.168.1.42:1080(lan) -> 127.0.0.1:1080(local)
socat \
  TCP-LISTEN:1080,bind=192.168.1.42,reuseaddr,fork,range=192.168.1.12/32 \
  TCP:127.0.0.1:1080

# lsof -nP -iTCP:1080 -sTCP:LISTEN
