#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


bin/elasticsearch-plugin install https://get.infini.cloud/elasticsearch/analysis-ik/8.18.0

echo "restart elasticsearch"
