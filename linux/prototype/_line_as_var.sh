#! /usr/bin/env bash
set -eu -o pipefail
# set -x
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

exit

while IFS= read -r line || [ -n "$line" ]; do
    "$line"
done < 'input.txt'

# || [ -n "$line" ] make sure include the last line which may not end with a newline

exit

IFS=$'\n'
for f in $(ls lesson*.mp4); do
    echo $f
done
