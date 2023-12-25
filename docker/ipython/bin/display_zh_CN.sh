#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

locale-gen zh_CN.UTF-8

export LANG=zh_CN.UTF-8
