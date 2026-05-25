#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

exit
systemctl status app

systemctl start app

systemctl stop app

systemctl daemon-reload

exit
journalctl -efxu app
sudo journalctl --vacuum-time=7d
