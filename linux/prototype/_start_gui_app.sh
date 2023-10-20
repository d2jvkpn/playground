#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

export DISPLAY=:0 # needed if running a gui app

/usr/bin/firefox &
