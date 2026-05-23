#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


journalctl -efxu app
sudo journalctl --vacuum-time=7d
