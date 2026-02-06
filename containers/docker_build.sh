#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


git_branch="$(git rev-parse --abbrev-ref HEAD)"
git_commit_id=$(git rev-parse --verify HEAD)
git_commit_time=$(git log -1 --format="%at" | xargs -I{} date -d @{} +%FT%T%:z)
