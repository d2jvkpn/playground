#! /usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

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

outdir=${1:-""}
clock=${clock:-0}

if [ "${clock}" == "1" ]; then
    outdir=${outdir}$(date +%FT%H-%M-%S)
elif [ "${clock}" == "2" ]; then
    outdir=${outdir}$(date +%FT%H-%M-%S-%s)
else
    outdir=${outdir}$(date +%F)
fi

mkdir -p $outdir
>&2 echo "~~~ created dir: $outdir"
