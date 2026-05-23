#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

exit
systemctl status app

systemctl start app

systemctl stop app

systemctl daemon-reload
