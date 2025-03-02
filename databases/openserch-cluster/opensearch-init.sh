#!//bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

mkdir -p data/opensearch-node01 data/opensearch-node02 data/opensearch-node03

if [ ! -s compose.yaml ]; then
    cp compose.template.yaml compose.yaml
else
    >&2 echo '!!! File exists: compose.yaml'
    exit 1
fi
