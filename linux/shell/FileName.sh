#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

file_name="$1"
# echo "==> $file_name"

new_name=$(basename "$file_name" | sed 's/ /_/g' | tr -dc '0-9a-zA-Z-._')
[ -z "$new_name" ] && { >&2 echo "new file name is empty"; exit 1; } 

echo "$new_name"

exit 0

sum=$(md5sum "$file_name" | awk '{print $1}')
echo $new_name.$(date +%s).$sum
