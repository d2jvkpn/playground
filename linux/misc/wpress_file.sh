#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname $0`)


# echo "Hello, world!"

npm install wpress-extract

npx wpress-extract path/to/file.wpress
