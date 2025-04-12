#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

#### print the line at the end of file and append a empty string
sed -n '$p; $a\ '
