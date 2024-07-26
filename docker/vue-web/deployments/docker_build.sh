#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

#### 1.
tag=$1
DOCKER_Pull=${DOCKER_Pull:-false}
DOCKER_Push=${DOCKER_Push:-false}

yaml=${yaml:-${_path}/docker_build.yaml}

git_branch=$(yq .$tag.branch $yaml)
image_name=$(yq .$tag.image_name $yaml)
VITE_API_URL=$(yq .$tag.VITE_API_URL $yaml)

app_name=$(yq -p json -o yaml package.json | yq .name)
app_version=$(yq -p json -o yaml package.json | yq .version)
# image_tag=${git_branch}-${app_version}
image_tag=$tag
image=$image_name:$image_tag

build_time=$(date +'%FT%T%:z')

#### 2.
mkdir -p cache.local

cat > cache.local/.env.prod <<EOF
VITE_API_URL = $VITE_API_URL
EOF

cat > cache.local/build.yaml << EOF
app_name: $app_name
app_version: $app_version
git_branch: $git_branch
build_time: $build_time

VITE_API_URL: $VITE_API_URL
EOF

#### 3. pull image
echo "==> Pull image(s) $image"

[[ "$DOCKER_Pull" != "false" ]] && \
for base in $(awk '/^FROM/{print $2}' ${_path}/Dockerfile); do
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

echo ">>> Building image: $image..."

# --build-arg=mode=$mode
docker build --no-cache --file ${_path}/Dockerfile --tag $image ./
docker image prune --force --filter label=stage=${app_name}_builder &> /dev/null

[ "$DOCKER_Push" != "false" ] && docker push $image

docker images --filter "dangling=true" --quiet $image | xargs -i docker rmi {}
