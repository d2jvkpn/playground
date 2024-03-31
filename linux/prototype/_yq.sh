#!/usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

cat | yq eval "explode(.) | .hello" <<EOF
containers: &containers
- { hello: world }
- { hello: 42 }

hello:
  world: 42
  containers: *containers
EOF
