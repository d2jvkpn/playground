#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


addr=$1
branch=${2:-main}
name=$(basename "$addr" .git)

git clone --branch "$branch" --depth 1 --single-branch "$addr" custom_nodes/"$name"

pip install --no-cache-dir -r custom_nodes/"$name"/requirements.txt
