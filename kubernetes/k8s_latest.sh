#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


# curl -s -L -o /dev/null -w '%{url_effective}\n' -v https://github.com/kubernetes/kubernetes/releases/latest 2>&1

url=https://github.com/kubernetes/kubernetes/releases/latest

output=$(curl --fail -s -L -o /dev/null -w '%{url_effective}\n' $url)
echo $output | awk -F "/" '{sub("^v", "", $NF); print $NF}'
