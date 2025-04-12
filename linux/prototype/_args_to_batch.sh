#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

[ $# -eq 0 ] && { >&2 echo '!!!'" no args"; exit 1; }

args=("$@")
batch_args=$(printf "{%s}" "$(IFS=,; echo "${args[*]}")")

echo target/"${batch_args}"

eval echo target/"${batch_args}"
