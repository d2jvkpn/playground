#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

#### 1.
tag=$1
DOCKER_Pull=${DOCKER_Pull:-false}
DOCKER_Push=${DOCKER_Push:-false}

yaml=${yaml:-${_path}/build.yaml}

# app_name=$(yq -p json -o yaml package.json | yq .name)
# app_version=$(yq -p json -o yaml package.json | yq .version)
app_name=$(yq .app_name $yaml)
app_version=$(yq .app_version $yaml)

image_name=$(yq .image_name $yaml)
image_tag=$(yq .$tag.image_tag $yaml)
image=$image_name:$image_tag

git_branch=$(yq .$tag.branch $yaml)
git_commit_id=$(git rev-parse --verify HEAD) # git log --pretty=format:'%h' -n 1
git_commit_time=$(git log -1 --format="%at" | xargs -I{} date -d @{} +%FT%T%:z)
git_tree_state="clean"
uncommitted=$(git status --short)
unpushed=$(git diff origin/$git_branch..HEAD --name-status)
# [[ ! -z "$uncommitted$unpushed" ]] && git_tree_state="dirty"
[[ ! -z "$unpushed" ]] && git_tree_state="unpushed"
[[ ! -z "$uncommitted" ]] && git_tree_state="uncommitted"

build_time=$(date +'%FT%T%:z')

VITE_API_URL=$(yq .$tag.VITE_API_URL $yaml)
VUE_APP_PUBLIC_PATH=$(yq .$tag.VUE_APP_PUBLIC_PATH $yaml)


#### 2.
mkdir -p cache.local

cat > cache.local/env <<EOF
VITE_API_URL=$VITE_API_URL
VUE_APP_PUBLIC_PATH=$VUE_APP_PUBLIC_PATH
EOF

cat > cache.local/build.yaml << EOF
app_name: $app_name
app_version: $app_version

git_branch: $git_branch
git_commit_id: $git_commit_id
git_commit_time: $git_commit_time
git_tree_state: $git_tree_state

build_time: $build_time

VITE_API_URL: $VITE_API_URL
VUE_APP_PUBLIC_PATH: $VUE_APP_PUBLIC_PATH
EOF

#### 3. pull image
echo "==> Pull image(s) $image"

[[ "$DOCKER_Pull" != "false" ]] && \
for base in $(awk '/^FROM/{print $2}' ${_path}/Containerfile); do
    echo ">>> pull $base"
    docker pull $base

    bn=$(echo $base | awk -F ":" '{print $1}')
    if [[ -z "$bn" ]]; then continue; fi
    docker images --filter "dangling=true" --quiet "$bn" | xargs -i docker rmi {}
done

#### 4.
function onExit {
    git checkout dev
}
trap onExit EXIT

git checkout $git_branch

echo "==> Building image: $image..."

# --build-arg=mode=$mode
docker build --no-cache --file ${_path}/Containerfile --tag $image \
  --build-arg=VUE_APP_PUBLIC_PATH="$(echo $VUE_APP_PUBLIC_PATH | sed 's#^/##; s#/$##')" \
  ./

docker image prune --force --filter label=stage=${app_name}_builder &> /dev/null

[ "$DOCKER_Push" != "false" ] && docker push $image
docker images --filter "dangling=true" --quiet $image | xargs -i docker rmi {}
