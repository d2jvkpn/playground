#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


# cd ${_path}

if [ $# -gt 0 ]; then
   git_list=$(cat $1)
else
   git_list=$(find -type d -name "\.git" | xargs -i dirname {})
fi

for d in $git_list; do
    cd $d
    echo "==> $(date +%FT%T%:z) $d"
    git pull || true
    cd ${_wd}
done
