#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


function main_logic {
    echo "This is main_logic."
}

function load_user_code {
    if [ -s ${_dir}/lib.sh ]; then
        source ${_dir}/lib.sh
    fi
}

main_logic

load_user_code

echo "exit"
