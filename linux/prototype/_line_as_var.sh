#! /usr/bin/env bash
set -eu -o pipefail
# set -x
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

while IFS= read -r line || [ -n "$line" ]; do
    "$line"
done < 'input.txt'

# || [ -n "$line" ] make sure include the last line which may not end with a newline
