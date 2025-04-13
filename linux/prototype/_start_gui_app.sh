#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(readlink -f `dirname $0`)

exit
####
export DISPLAY=:0 # needed if running a gui app

/usr/bin/firefox &

####
grep Exec /usr/share/applications/firefox.desktop
