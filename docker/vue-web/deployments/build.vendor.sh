#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

BUILD_Vendor=true bash ${_path}/build.sh $*
