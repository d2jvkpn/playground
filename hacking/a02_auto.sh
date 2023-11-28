#! /usr/bin/env bash
set -eu -o pipefail
# author: ChatGPT

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

function main_logic {
    echo "This is main_logic."
}

function load_user_code {
    if [ -f a02_lib.sh ]; then
        source a02_lib.sh
    fi
}

main_logic

load_user_code

echo "exit"
