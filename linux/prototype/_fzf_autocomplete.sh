#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

choices=$(cat configs/choices.txt | fzf)

echo $choices
