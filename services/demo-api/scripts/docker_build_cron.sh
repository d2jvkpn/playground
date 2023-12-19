#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

cd $(dirname ${_path})

branch=${branch:-master}
tag=${tag:-dev}
hours=${hours:-24}
image=$(yq .image project.yaml):$tag

git checkout $branch
git pull

commit_ts=$(git log -1 --format="%at")
commit_at=$(date -d @$commit_ts +%FT%T%:z)
# created_at=$(docker images --format json $image | jq .CreatedAt)
created_at=$(docker inspect -f '{{ .Created }}' $image || true)

if [ -z "$created_at" ]; then
    >&2 echo "==> docker build..."
    DOCKER_Tag=$tag bash deployments/docker_build.sh $branch
    exit 0
fi
created_ts=$(date -d "$created_at" +%s)

if [ $(($commit_ts - $created_ts)) -lt $(($hours * 60 * 60)) ]; then
    >&2 echo "==> abort: git-commit-at=$commit_at, image-created-at=$created_at"
    exit 0
fi

>&2 echo "==> docker build..."
DOCKER_Tag=$tag bash deployments/docker_build.sh $branch
