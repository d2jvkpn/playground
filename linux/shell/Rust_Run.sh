#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

script=$1; shift; args=$*
out=target/$(basename $script | sed 's/.rs$//') # out=/tmp/$(basename $script | sed 's/.rs$//')

mkdir -p target
rustfmt $script

if [ "${release:-false}" == "true" ]; then
    rustc -C opt-level=3 -o "$out" "$script"
else
    rustc -o "$out" "$script"
fi

"$out" $args

exit

function cleanup {
    echo "==> removing $out"
    rm -f "$out"
}

trap cleanup EXIT

"$out" $args
