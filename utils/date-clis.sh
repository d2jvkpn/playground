#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

#### rfc3339
date --rfc-3339=seconds | sed "s/ /T/"

date +%FT%T%:z

#### convert
git log -1 --format="%at" | xargs -I{} date -d @{} +%FT%T%:z
