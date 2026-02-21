#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


####
pull=${pull:-false}
remove=${remove:-false}

image=$1
name=$(echo "$image" | sed 's#/#--#g; s#:#--#')
tag=$(echo "$image" | awk -F ":" '{print $2}')
if [[ "$tag" == *"latest" ]]; then
    name="$name.$(date +%F)"
fi
echo "name: $name"

####
if [[ "$image" != *":"* ]]; then
    >&2 echo '!!! Expected image with :tag'
    exit 1
fi

####
if [[ "$pull" == "true" ]]; then
    echo "$(date +%F:%T%:z) Pulling $image"
    docker pull "$image"
fi

echo "$(date +%F:%T%:z) Exporting $image"
#docker save "$image" -o "$name".tar
#pigz -f "$name".tar

docker save "$image" | gzip -c > "$name".tgz.tmp
mv "$name".tgz.tmp "$name".tgz
echo "$(date +%F:%T%:z) Saved $image to $name.tgz"

if [[ "$remove" == "true" ]]; then
    echo "$(date +%F:%T%:z) Removing image $image"
    docker rmi "$image" || true
fi

echo "$(date +%F:%T%:z) Done"
