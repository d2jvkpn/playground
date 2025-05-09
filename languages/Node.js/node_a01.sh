#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


# echo "Hello, world!"

npm install --global typescript@5.0.2

npm install --save-dev @types/node
npm uninstall @types/node
npm fund

npm update
