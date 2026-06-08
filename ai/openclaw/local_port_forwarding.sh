#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

exit
autossh -M 0 -f -N -L 18789:127.0.0.1:18789 <remote_host>
