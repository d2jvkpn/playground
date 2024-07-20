#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# echo "Hello, world!"

git diff -- ':!bin/*'

git branch test
git checkout test
git push --set-upstream origin test
