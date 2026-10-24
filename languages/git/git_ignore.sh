#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

####
grep ".env" .gitignore

git add -f .env

git commit -m "add template file .env"

####
git update-index --skip-worktree .env
