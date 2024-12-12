#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

function display_usage() {
>&2 cat <<'EOF'
Usage of docker_clean.sh:

help:
  docker_clean.sh [help | -h | --help]

remove dangling images(dangling=true):
  docker_clean.sh image

remove exited containers(status=exited):
  docker_clean.sh container
EOF
}

if [ $# -ne 1 ]; then
    display_usage
    exit 0
fi

action=$1

case "$action" in
"image")
    docker images --filter "dangling=true" --quiet | xargs -i docker rmi {}
    ;;
"container")
    docker ps --filter "status=exited" --quiet | xargs -i docker rm {}
    ;;
"help" | "-h" | "--help")
    display_usage
    exit 0
    ;;
*)
    display_usage
    exit 1
    ;;
esac
