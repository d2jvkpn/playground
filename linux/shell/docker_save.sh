#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


####
remove=${remove:-false}

image=$1
name=$(echo "$image" | sed 's#/#--#g; s#:#--#')

####
if [[ "$image" != *":"* ]]; then
   >&2 echo '!!! expected image with :tag'
   exit 1
fi

####
echo "--> exporting $image"
docker save "$image" -o "$name".tar

pigz -f "$name".tar
echo "--> saved to "$name".tar.gz"

if [[ "$remove" == "true" ]]; then
    echo "--> remove image $image"
    docker rmi "$image" || true
fi
