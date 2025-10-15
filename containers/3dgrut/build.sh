#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


mkdir -p data logs

[ -d data/3dgrut.git ] && rm -rf data/3dgrut.git

git clone https://github.com/nv-tlabs/3dgrut data/3dgrut.git

cd data/3dgrut.git

docker build . -f Dockerfile -t local/3dgrut:base &> ${_wd}/logs/local--3dgrut--base.docker-build.log

cd ${_wd}
docker build . -f Containerfile -t local/3dgrut:latest &> logs/local--3dgrut--lastest.docker-build.log
