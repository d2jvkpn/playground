#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


mkdir -p $HOME/.docker/cli-plugins

wget -O  $HOME/.docker/cli-plugins/docker-buildx \
  https://github.com/docker/buildx/releases/download/v0.23.0/buildx-v0.23.0.linux-amd64

chmod +x $HOME/.docker/cli-plugins/docker-buildx


exit

```Containerfile
RUN --mount=type=bind,target=cache,source=cache ls cache
```
