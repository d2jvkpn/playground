#! /usr/bin/env bash
set -eu -o pipefail
# set -x
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

function display_usage() {
>&2 cat <<'EOF'
#### This script generates a directory named after the date.

#### Usage:
env args:
- clock: 0(%F), 1(%FT%H-%M-%S), 2(%FT%H-%M-%S-%s)
position args:
- $1: prefix, e.g. "my_"
EOF
}

if [[ $# -ge 1 && ("$1" == "--help" ||  "$1" == "-h") ]]; then
    display_usage
    exit 1
fi
