#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

####
[ $# -eq 0 ] && { >&2 echo "Argument {branch} is required!"; exit 1; }
git_branch=$1

image="registry.cn-shanghai.aliyuncs.com/d2jvkpn/http-auth-proxy"
tag=${git_branch}-$(yq .version project.yaml)
tag=${DOCKER_Tag:-$tag}
app_name=http-auth-proxy
BUILD_Region=cn=${BUILD_Region:-""}

function onExit {
    git checkout dev # --force
}
trap onExit EXIT

git checkout $git_branch
# [[ "$BuildLocal" != "true" ]] && git pull --no-edit

build_time=$(date +'%FT%T%:z')
git_branch="$(git rev-parse --abbrev-ref HEAD)" # current branch
git_commit_id=$(git rev-parse --verify HEAD) # git log --pretty=format:'%h' -n 1
git_commit_time=$(git log -1 --format="%at" | xargs -I{} date -d @{} +%FT%T%:z)
git_tree_state="clean"

uncommitted=$(git status --short)
unpushed=$(git diff origin/$git_branch..HEAD --name-status)
[[ ! -z "$uncommitted$unpushed" ]] && git_tree_state="dirty"

####
for base in $(awk '/^FROM/{print $2}' ${_path}/Dockerfile); do
    echo ">>> pull $base"
    docker pull $base
    bn=$(echo $base | awk -F ":" '{print $1}')
    if [[ -z "$bn" ]]; then continue; fi
    docker images --filter "dangling=true" --quiet "$bn" | xargs -i docker rmi {}
done

echo ">>> build image: $image:$tag..."

GO_ldflags="-X main.build_time=$build_time -X main.git_branch=$git_branch \
  -X main.git_commit_id=$git_commit_id -X main.git_commit_time=$git_commit_time \
  -X main.git_tree_state=$git_tree_state"

df=${_path}/Dockerfile

docker build --no-cache --file $df \
  --build-arg=BUILD_Region="$BUILD_Region" \
  --build-arg=GO_ldflags="$GO_ldflags" \
  --tag $image:$tag ./

docker image prune --force --filter label=stage=${app_name}_builder &> /dev/null

#### push image
echo ">>> push image: $image:$tag..."
docker push $image:$tag

images=$(docker images --filter "dangling=true" --quiet $image)
for img in $images; do docker rmi $img || true; done &> /dev/null
