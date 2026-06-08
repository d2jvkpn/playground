#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


ls data/list*.json |
    xargs -n 1 -P 4 python3 selenium_s02.py --headless --json_file {}
