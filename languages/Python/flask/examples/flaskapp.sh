#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


sudo systemctl start flaskapp

sudo journalctl -u flaskapp -f

systemctl restart flaskapp
