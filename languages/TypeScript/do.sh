#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

####
npm install -g typescript
command -v tsc

tsc a01.ts
node a01.js
