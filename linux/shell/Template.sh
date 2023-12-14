#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

templ=$1
[[ "$templ" = *"."* ]] || templ=${templ}.${templ}
out=${2:-${templ}}

[ -f "$out" ] && { >&2 echo '!!!'" file exists: $out"; exit 1; }

cp ~/Templates/$templ $out
echo "~~ created $out"
