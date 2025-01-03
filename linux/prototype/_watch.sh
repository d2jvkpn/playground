#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


watch -n 2 -g "stat logs/target.txt"
