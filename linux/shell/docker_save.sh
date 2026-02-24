#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


####
pull=${pull:-false}
remove=${remove:-false}

image=$1
if [[ "$image" != *":"* ]]; then
    >&2 echo '!!! Expected image with :tag'
    exit 1
fi

basename=$(echo "$image" | sed 's#/#--#g; s#:#--#')
tag=$(echo "$image" | awk -F ":" '{print $2}')

if [[ "$tag" == "latest" ]]; then
    #basename="$basename.$(date +%F)"
    created=$(docker inspect $image | jq -r '.[0].Created' | awk -F "T" '{print $1; exit}')
    basename="$basename.$created"
fi

####
if [[ "$pull" == "true" ]]; then
    echo "$(date +%F:%T%:z) Pulling $image"
    docker pull "$image"
fi

echo "$(date +%F:%T%:z) Exporting $image: $basename"
#docker save "$image" -o "$basename".tar
#pigz -f "$basename".tar

zipper=gzip
if command -v pigz >/dev/null 2>&1; then
    zipper="pigz -p 4"
fi

docker save "$image" | $zipper -c > "$basename".tgz.tmp
mv "$basename".tgz.tmp "$basename".tgz
echo "$(date +%F:%T%:z) Saved $image to $basename.tgz"

if [[ "$remove" == "true" ]]; then
    echo "$(date +%F:%T%:z) Removing image $image"
    docker rmi "$image" || true
fi

echo "$(date +%F:%T%:z) Done"
