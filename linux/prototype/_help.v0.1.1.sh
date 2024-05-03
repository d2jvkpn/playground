#!//bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

function display_usage() {
>&2 cat <<'EOF'
Usage of docker_deploy.sh(postgres):

help:
  ./docker_deploy.sh [help | -h | --help]

run:
  ./docker_deploy.sh run [DB_Port:-5432] [CONTAINER_Name:-postgres]
EOF
}

case "${1:-help}" in
"run")
    ;;
"help" | "-h" | "--help")
    display_usage
    exit 1
    ;;
"*")
    display_usage
    exit 1
    ;;
esac

export DB_Port=${2:-5432} CONTAINER_Name=${3:-postgres}
