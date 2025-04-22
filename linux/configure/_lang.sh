#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


locale

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
