#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

watch -n 2 -g "state logs/file.txt"
