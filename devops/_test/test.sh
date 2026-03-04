#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
docker build -t local/test ./

docker run --rm -it local/test cat test.txt

docker rmi local/test
