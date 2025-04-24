#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


source_path=$1
target_path=$2

msg="source_path=$source_path, target_path=$target_path"

echo "==> $(date +%FT%T%:z) start oss copy: $msg"

until ossutil -c oss.ini cp -r "$source_path" "$target_path"; do
    echo "--> $(date +%FT%T%:z) try again in 5s: $msg"
    sleep 5
done

echo "<== $(date +%FT%T%:z) oss copy is done: $msg"
