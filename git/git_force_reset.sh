#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


#### soft
exit
git reset --soft HEAD~1

####
git reset HEAD~1
git reset --mixed HEAD~1

####
exit
git reset --hard HEAD~1

git revert HEAD

git reset --soft HEAD~1

git push origin <branch-name> --force

git push origin <branch-name> --force-with-lease
