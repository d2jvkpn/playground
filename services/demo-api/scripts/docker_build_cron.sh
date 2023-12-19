#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

cd $(dirname ${_path})

branch=${branch:-master}
tag=${tag:-dev}
minutes=${minutes:-60}
image=$(yq .image project.yaml):$tag

git checkout $branch
git pull

commit_ts=$(git log -1 --format="%at")
commit_at=$(date -d @$commit_ts +%FT%T%:z)
created_at=$(docker inspect -f '{{ .Created }}' $image || true) # docker images --format json $image 

if [ -z "$created_at" ]; then
    >&2 echo "==> docker build..."
    DOCKER_Tag=$tag bash deployments/docker_build.sh $branch
    exit 0
fi
created_ts=$(date -d "$created_at" +%s)

if [ $created_ts -ge $commit_ts ]; then
    >&2 echo "==> abort: git-commit=$commit_at, image-created=$created_at"
    exit 0
fi

now_at=$(date +%FT%T%:z)
now_ts=$(date -d $now_at +%s)
if [ $(($commit_ts - $now_ts)) -ge $(($minutes * 60)) ]; then
    >&2 echo "==> abort: git-commit=$commit_at, now=$now_at"
    exit 0
fi

>&2 echo "==> docker build..."
DOCKER_Tag=$tag bash deployments/docker_build.sh $branch
