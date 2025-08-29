#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

length=${1:-16}

token=$(tr -dc '0-9a-z' < /dev/urandom | fold -w $length | head -n 1 || true)

cat > container.env <<EOF
JUPYTER_TOKEN=$token
EOF
