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

echo "==> image: $image"
#docker-archive:/dev/stdout:$image
skopeo copy docker://$image docker-archive:$prefix.tar:$image
pigz $prefix.tar

mv $prefix.tar.gz $prefix.tgz
echo "<== saved: $prefix.tgz"
