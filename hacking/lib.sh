#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


function main_logic {
    echo "This is main_logic after modification ."
}

function new_feature {
    echo "This is new_feature."
}
