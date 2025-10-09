#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


####
pull=${pull:-false}
remove=${remove:-false}

image=$1
name=$(echo "$image" | sed 's#/#--#g; s#:#--#')

####
if [[ "$image" != *":"* ]]; then
   >&2 echo '!!! expected image with :tag'
   exit 1
fi

####
if [[ "$pull" == "true" ]]; then
    echo "--> pulling $image"
    docker pull "$image"
fi

echo "--> exporting $image"
#docker save "$image" -o "$name".tar
#pigz -f "$name".tar

docker save "$image" | pigz -c > "$name".tar.gz.tmp
mv "$name".tar.gz.tmp "$name".tar.gz

echo "--> saved to "$name".tar.gz"

if [[ "$remove" == "true" ]]; then
    echo "--> remove image $image"
    docker rmi "$image" || true
fi
