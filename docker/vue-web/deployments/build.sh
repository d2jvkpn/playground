#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# branch="$1" # git branch
mode="$1"   # load .env.${mode}
tag=$mode   # image tag

awk '!/^#/{sub(" += +", "=", $0); print "export "$0}' .env.${mode} > ./config.env
. ./config.env

branch=$(printenv BRANCH)
build_vendor=$(printenv BUILD_Vendor || true)

echo "Mode: $mode, BRANCH: $branch"

#
name="registry.cn-shanghai.aliyuncs.com/d2jvkpn/vue-web"
image="$name:$tag"
echo ">>> building image: $image..."

function onExit {
    git checkout dev
}
trap onExit EXIT


git checkout $branch

[[ "$build_vendor" != "true" ]] && {
    echo ">>> git pull..."
    git pull --no-edit
}

#
df=${_path}/Dockerfile
[[ "$build_vendor" == "true" ]] && df=${_path}/Dockerfile.vendor

if [[ "$build_vendor" != "true" ]]; then
    echo ">>> Pull base images..."
    for base in $(awk '/^FROM/{print $2}' $df); do
        docker pull --quiet $base
        bn=$(echo $base | awk -F ":" '{print $1}')
        if [[ -z "$bn" ]]; then continue; fi
        docker images --filter "dangling=true" --quiet "$bn" | xargs -i docker rmi {}
    done &> /dev/null
fi

docker build --no-cache -f $df \
  --build-arg=mode=$mode       \
  --build-arg=VUE_APP_BuildTime=$(date +'%FT%T%:z') \
  -t $image .

docker image prune --force --filter label=stage=vue-web_builder &> /dev/null
for img in $(docker images --filter=dangling=true $name --quiet); do
    docker rmi $img &> /dev/null
done

[[ "$build_vendor" != "true" ]] && {
    echo ">>> pushing image: $image"
    docker push $image
}
