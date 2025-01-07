#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

sudo nginx -t
sudo nginx -s reload
