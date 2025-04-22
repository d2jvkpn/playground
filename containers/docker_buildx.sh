#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


target_dir=${1:-$HOME/.docker}

mkdir -p $target_dir/cli-plugins

wget -O  $target_dir/cli-plugins/docker-buildx \
  https://github.com/docker/buildx/releases/download/v0.23.0/buildx-v0.23.0.linux-amd64

chmod +x $target_dir/cli-plugins/docker-buildx


exit
```Containerfile
RUN --mount=type=bind,target=cache,source=cache ls cache/
```
