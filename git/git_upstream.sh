#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

#### 1. add upstream repository
git remote add upstream https://github.com/go-shiori/shiori.git

#### 2. fetch upstream
git fetch upstream

#### 3. merge codes
git checkout master        # main
git merge upstream/master  # upstream/main

#### 4. resolve conflicts
git add .
git commit -m "Resolved merge conflicts..."

#### 5. push to your repository
git push origin main
