#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

netstat -ntlp

netstat -ano | grep -w 42221

lsof -i :42221

netstat -anp | grep 42221
