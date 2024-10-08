#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

####
mkdir -p cache.local
[ -d frp.git ] || git clone -b master git@github.com:fatedier/frp.git frp.git

# app_version=0.60.0
# wget -O cache.local/frp-${app_version}.tar.gz \
#   https://codeload.github.com/fatedier/frp/tar.gz/refs/tags/v${app_version}
# tar -xf cache.local/frp-${app_version}.tar.gz -C cache.local
# mv cache.local/frp-${app_version} frp.git

BUILD_Region=${BUILD_Region:-""}
app_version=""
app_name=frp
image_name=frp
image_tag=latest
image=$image_name:$image_tag

build_time=$(date +'%FT%T%:z')

cd frp.git

git_repository="$(git config --get remote.origin.url)"

git_branch="$(git rev-parse --abbrev-ref HEAD)" # current branch
git_commit_id=$(git rev-parse --verify HEAD) # git log --pretty=format:'%h' -n 1
git_commit_time=$(git log -1 --format="%at" | xargs -I{} date -d @{} +%FT%T%:z)
git_tree_state="clean"
uncommitted=$(git status --short)
unpushed=$(git diff origin/$git_branch..HEAD --name-status)
# [[ ! -z "$uncommitted$unpushed" ]] && git_tree_state="dirty"
[[ ! -z "$unpushed" ]] && git_tree_state="unpushed"
[[ ! -z "$uncommitted" ]] && git_tree_state="uncommitted"

cd ${_wd}

####
cat > cache.local/build.yaml << EOF
app_name: $app_name
app_version: $app_version
git_repository: $git_repository
git_branch: $git_branch
git_commit_id: $git_commit_id
git_commit_time: $git_commit_time
git_tree_state: $git_tree_state

build_time: $build_time
image: $image
EOF

docker build --no-cache --file Dockerfile \
  --build-arg=APP_Name="$app_name" \
  --build-arg=BUILD_Region="$BUILD_Region" \
  --tag $image ./

docker save $image -o cache.local/${image_name}_${image_tag}.tar
pigz cache.local/${image_name}_${image_tag}.tar
