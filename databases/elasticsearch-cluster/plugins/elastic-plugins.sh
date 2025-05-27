#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


bin/elasticsearch-plugin install \
  https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v8.18.0/elasticsearch-analysis-ik-8.18.0.zip

bin/elasticsearch-plugin install analysis-icu

# bin/elasticsearch-plugin install https://get.infini.cloud/elasticsearch/analysis-ik/8.18.0
