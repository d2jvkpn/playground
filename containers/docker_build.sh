#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

exit
git_branch="$(git rev-parse --abbrev-ref HEAD)"
git_commit_id=$(git rev-parse --verify HEAD)
git_commit_time=$(git log -1 --format="%at" | xargs -I{} date -d @{} +%FT%T%:z)

exit
docker buildx create \
  --name builder-01 \
  --driver docker-container \
  --driver-opt env.HTTP_PROXY=http://172.17.0.1:1080 \
  --driver-opt env.HTTPS_PROXY=http://172.17.0.1:1080 \
  --use \
  --bootstrap

# docker pull moby/buildkit:buildx-stable-1

docker buildx ls

docker buildx inspect --bootstrap

docker buildx rm builder-01

docker build \
  -f Containerfile \
  --builder builder-01 \
  --output type=oci,dest=- \
  -t my-image:latest ./ | \
  pigz > my-image--latest.tgz
