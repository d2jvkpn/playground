#!/usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})


cat | yq 'explode(.) | del .bill-to' << 'EOF'
bill-to: &id001
  given: Chris
  family: Dumars

ship-to:
- *id001

target: *id001
EOF


cat | yq '.ship-to[0] | explode(.) | keys | join(", ")' << 'EOF'
bill-to: &id001
  given: Chris
  family: Dumars

ship-to:
- *id001

target: *id001
EOF
