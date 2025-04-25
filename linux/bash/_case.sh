#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


action=$1

case "$action" in
"1" | "step1")
    date +"==> %FT%T step1"
    ;;
"2" | "step2")
    date +"==> %FT%T.%N step2"
    ;;
"3" | "step3")
    date +"==> %FT%T.%N%:z step3"
    ;;
*)
    >&2 echo "unknown arg: $action"
    exit 1
esac
