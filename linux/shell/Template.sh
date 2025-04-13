#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(readlink -f `dirname "$0"`)


templ=$1
[[ "$templ" = *"."* ]] || templ=${templ}.${templ}

out=${2:-${templ}}
[[ "$out" = *"."* ]] || out=$out.${templ##*.}
mkdir -p "$(dirname "$out")"

[ -f "$out" ] && { >&2 echo '!!!'" file exists: $out"; exit 1; }

cp ~/Templates/$templ $out
echo "~~ created $out"
