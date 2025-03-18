#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

# echo "Hello, world!"

npm install http-server -g
http-server -o dist
