#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
ls -d .[!.]* ..?*

find . -mindepth 1 -maxdepth 1 -name '.*'

find . -mindepth 1 -maxdepth 1 -name '.*' -printf '%f\n'

find . -mindepth 1 -maxdepth 1 -name '.*' | sed 's|^\./||'
