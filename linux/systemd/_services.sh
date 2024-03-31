#!/usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

systemctl status app

systemctl start app

systemctl stop app

journalctl -efxu app
