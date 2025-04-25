#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


cat | yq eval "explode(.) | .hello" <<EOF
containers: &containers
- { hello: world }
- { hello: 42 }

hello:
  world: 42
  containers: *containers
EOF
