#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

nodes=(node{01..05})

echo "==> first element ${nodes[0]}"

echo "==> range 1..3 ${nodes[@]:1:3}"

echo "==> range 1.. ${nodes[@]:1}"
