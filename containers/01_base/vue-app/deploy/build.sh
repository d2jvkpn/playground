#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

#### 1.
tag=$1
# GIT_Pull=$(printenv GIT_Pull || true)
GIT_Pull=${GIT_Pull:-"true"}
DOCKER_Pull=${DOCKER_Pull:-false}
DOCKER_Push=${DOCKER_Push:-false}
region=${region:-""}

yaml=${yaml:-${_path}/build.yaml}

# app_name=$(yq -p json -o yaml package.json | yq .name)
# app_version=$(yq -p json -o yaml package.json | yq .version)
app_name=$(yq .app_name $yaml)
app_version=$(yq .app_version $yaml)

image_name=$(yq .image_name $yaml)
image_tag=$(yq .$tag.image_tag $yaml)
image=$image_name:$image_tag

build_time=$(date +'%FT%T%:z')
build_host=$(hostname)

git_branch=$(yq .$tag.branch $yaml)
git_commit_id=$(git rev-parse --verify HEAD) # git log --pretty=format:'%h' -n 1
git_commit_time=$(git log -1 --format="%at" | xargs -I{} date -d @{} +%FT%T%:z)
git_tree_state="clean"
uncommitted=$(git status --short)
unpushed=$(git diff origin/$git_branch..HEAD --name-status)
# [[ ! -z "$uncommitted$unpushed" ]] && git_tree_state="dirty"
[[ ! -z "$unpushed" ]] && git_tree_state="unpushed"
[[ ! -z "$uncommitted" ]] && git_tree_state="uncommitted"

if [[ "$GIT_Pull" != "false" && ! -z "$uncommitted$unpushed" ]]; then
    >&2 echo '!!! '"git state is dirty"
    exit 1
fi

[[ "$GIT_Pull" != "false" ]] && git pull --no-edit

VUE_APP_PUBLIC_PATH=$(yq .$tag.VUE_APP_PUBLIC_PATH $yaml)
VUE_APP_API_URL=$(yq .$tag.VUE_APP_API_URL $yaml)


#### 2.
mkdir -p cache.local

cat > cache.local/env <<EOF
VUE_APP_PUBLIC_PATH=$VUE_APP_PUBLIC_PATH
VUE_APP_API_URL=$VUE_APP_API_URL
EOF

cat > cache.local/build.yaml <<EOF
app_name: $app_name
app_version: $app_version

git_branch: $git_branch
git_commit_id: $git_commit_id
git_commit_time: $git_commit_time
git_tree_state: $git_tree_state

build_time: $build_time

VUE_APP_PUBLIC_PATH: $VUE_APP_PUBLIC_PATH
VUE_APP_API_URL: $VUE_APP_API_URL
EOF

yq -o json cache.local/build.yaml > cache.local/build.json

#### 3. pull image
[[ "$DOCKER_Pull" != "false" ]] && \
for base in $(awk '/^FROM/{print $2}' ${_path}/Containerfile); do
    echo ">>> Pull $base"
    docker pull $base

    bn=$(echo $base | awk -F ":" '{print $1}')
    if [[ -z "$bn" ]]; then continue; fi
    docker images --filter "dangling=true" --quiet "$bn" | xargs -i docker rmi {}
done


#### 4.
function onExit {
    git checkout dev || true
}
trap onExit EXIT

git checkout $git_branch

echo "==> Building image=$image, base_path=$VUE_APP_PUBLIC_PATH"

# --build-arg=mode=$mode
docker build --no-cache --tag $image \
  --file ${_path}/Containerfile \
  --build-arg=APP_Name=$app_name \
  --build-arg=APP_Version=$app_version \
  --build-arg=BASE_Path="$VUE_APP_PUBLIC_PATH" \
  --build-arg=region="$region" \
  ./

[ "$DOCKER_Push" != "false" ] && docker push $image

#### 5.
docker image prune --force --filter label=app=${app_name} --filter label=stage=build &> /dev/null

# docker images --filter "dangling=true" --quiet $image | xargs -i docker rmi {}
for img in $(docker images --filter=dangling=true --filter=label=app=$app_name --quiet); do
    docker rmi $img || true
done
