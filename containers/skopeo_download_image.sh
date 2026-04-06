#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

image=$1

name=$(echo "$image" | sed 's#/#--#g; s#:#--#')

skopeo copy docker://docker.io/library/$image docker-archive:/dev/stdout:$image |
  pigz -c > $name.tgz
