#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

function main_logic {
    echo "This is main_logic after modification ."
}

function new_feature {
    echo "This is new_feature."
}
