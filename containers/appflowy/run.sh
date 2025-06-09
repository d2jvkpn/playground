#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname $0`)


mkdir -p cache
git clone --branch main https://github.com/AppFlowy-IO/AppFlowy-Cloud cache/AppFlowy-Cloud.git
