#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


mkdir -p data
git clone --branch main https://github.com/SagerNet/sing-box data/SagerNet--sing-box.git
