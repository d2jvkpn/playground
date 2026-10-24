#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
git worktree list

git worktree add ../wt-login feature/login
# --> commit

git worktree remove ../wt-login

exit
git status

git worktree add -b hotfix/urgent ../wt-hotfix origin/main

cd ../wt-hotfix
git commit -am "fix: urgent bug"

git worktree remove ../wt-hotfix

# git worktree prune
