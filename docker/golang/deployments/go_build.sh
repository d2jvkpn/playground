#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

command -v git
command -v go
command -v yq

target_dir=${_wd}/target
goto_dir=${1:-""}
[ ! -z "$goto_dir" ] && cd "$goto_dir"

app_name=$(yq .app_name project.yaml)
app_version=$(yq .version project.yaml)
image_name=$(yq .image_name project.yaml)

# build_time=$(date +'%FT%T.%N%:z')
build_time=$(date +'%FT%T%:z')
build_host=$(hostname)
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

GO_ldflags="\
  -X main.build_time=$build_time \
  -X main.build_host=$build_host \
  -X main.git_branch=$git_branch \
  -X main.git_commit_id=$git_commit_id \
  -X main.git_commit_time=$git_commit_time \
  -X main.git_tree_state=$git_tree_state"

#  -X main.git_repository=$git_repository
#  -X main.image=${image}:${git_branch}-${app_version}

mkdir -p $target_dir

# go build -ldflags="-w -s $GO_ldflags" -o target/$app_name main.go
go build -ldflags="$GO_ldflags" -o $target_dir/$app_name main.go
# GOOS=windows GOARCH=amd64 go build -ldflags="$GO_ldflags" -o target/$app_name.exe main.go

ls -l $target_dir
