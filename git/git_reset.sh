#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

exit

# 回退最后一次 commit，但保留改动
git reset --soft HEAD~1

# 回退 commit + 改动，放回暂存区前
git reset --mixed HEAD~1

# 回退 commit 且删除所有改动
git reset --hard HEAD~1

# 撤销 commit 并生成新的反向 commit
git revert <commit>
