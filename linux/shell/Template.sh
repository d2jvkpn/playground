#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})


templ=$1
[[ "$templ" = *"."* ]] || templ=${templ}.${templ}

out=${2:-${templ}}
[[ "$out" = *"."* ]] || out=$out.${templ##*.}
mkdir -p "$(dirname "$out")"

[ -f "$out" ] && { >&2 echo '!!!'" file exists: $out"; exit 1; }

cp ~/Templates/$templ $out
echo "~~ created $out"
