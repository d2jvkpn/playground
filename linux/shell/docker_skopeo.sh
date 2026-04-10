#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


output_dir=${output_dir:-./}
image=$1
prefix=${output_dir%/}/$(echo "$image" | sed 's#/#--#g; s#:#--#')

skopeo copy docker://docker.io/$image \
  docker-archive:/dev/stdout:$image |
  pigz -c > $prefix.tgz.tmp

mv $prefix.tgz.tmp $prefix.tgz
