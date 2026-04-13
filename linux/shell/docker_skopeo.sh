#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


output_dir=${output_dir:-./}
name=$1
prefix=${output_dir%/}/$(echo "$name" | sed 's#/#--#g; s#:#--#')

first="${name%%/*}"
if [[ "$first" == "localhost" || "$first" == *.* || "$first" == *:* ]]; then
    image=$name
else
    image=docker.io/$name
fi


skopeo copy docker://$image docker-archive:/dev/stdout:$image |
  pigz -c > $prefix.tgz.tmp

mv $prefix.tgz.tmp $prefix.tgz
