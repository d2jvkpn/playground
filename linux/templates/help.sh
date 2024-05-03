#!//bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

function display_usage() {
>&2 cat <<'EOF'
Usage of docker_deploy.sh:
TODO:

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
