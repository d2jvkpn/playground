#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit

while IFS= read -r line || [ -n "$line" ]; do
    echo "$line"
done < 'input.txt'

# || [ -n "$line" ] make sure include the last line which may not end with a newline

exit

IFS=$'\n'
for f in $(ls lesson*.mp4); do
    echo $f
done
