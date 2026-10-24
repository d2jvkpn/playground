#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(readlink -f `dirname "$0"`)


#### 1. when some remote branch was deleted
git gc --prune=now

git fetch --all --prune # git fetch -p

git fetch --all
git pull --all
