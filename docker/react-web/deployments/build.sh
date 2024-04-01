#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# BRANCH="$1"
# ENV_File="$2"
# TAG=$3

# "./configs/$APP_ENV.env"
ENV_File="$1"
APP_ENV=$(basename $ENV_File | sed 's/.env$//')
TAG=$APP_ENV

. $ENV_File
build_vendor=$(printenv BUILD_Vendor || true)

echo ">>> ENV_File: $ENV_File, BRANCH: $BRANCH, TAG: $TAG"

function on_exit {
    git checkout dev
}
trap on_exit EXIT

####
git checkout $BRANCH
git pull --no-edit

####
df=${_path}/Dockerfile

name="registry.cn-shanghai.aliyuncs.com/d2jvkpn/react-web"
image="$name:$TAG"
echo ">>> building image: $image..."

echo ">>> Pull base images..."
for base in $(awk '/^FROM/{print $2}' $df); do
    docker pull --quiet $base
    bn=$(echo $base | awk -F ":" '{print $1}')
    if [[ -z "$bn" ]]; then continue; fi

    docker images --filter "dangling=true" --quiet "$bn" |
      xargs -i docker rmi {}
done &> /dev/null

docker build --no-cache -f $df -t $image  \
  --build-arg=APP_ENV=$APP_ENV            \
  --build-arg=ENV_File=$ENV_File          \
  --build-arg=REACT_APP_BuildTime=$(date +'%FT%T%:z')  \
  ./

docker image prune --force --filter label=stage=react-web_builder &> /dev/null

for img in $(docker images --filter=dangling=true $name --quiet); do
    docker rmi $img &> /dev/null
done

#### push to registry
[[ "$build_vendor" != "true" ]] && {
    echo ">>> pushing image: $image"
    docker push $image
}
