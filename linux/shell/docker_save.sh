#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


####
out_dir=${out_dir:-./}
pull=${pull:-false}
remove=${remove:-false}
platform=${platform:-}

image=$1
if [[ "$image" != *":"* ]]; then
    >&2 echo '!!! Expected image with :tag'
    exit 1
fi

basename=$(echo "$image" | sed 's#/#--#g; s#:#--#')
tag=$(echo "$image" | awk -F ":" '{print $2}')

if [[ "$tag" == "latest" ]]; then
    if [[ -n "$platform" ]]; then
        created=$(docker image inspect --platform "$platform" "$image" 2>/dev/null \
                  | jq -r '.[0].Created' | awk -F "T" '{print $1; exit}')
    else
        created=$(docker inspect "$image" | jq -r '.[0].Created' | awk -F "T" '{print $1; exit}')
    fi
    basename="$basename.$created"
fi

# 平台后缀，用于区分不同平台的 tar 包
if [[ -n "$platform" ]]; then
    platform_suffix=$(echo "$platform" | sed 's#[/,]#-#g')
    basename="${basename}.${platform_suffix}"
fi

####
if [[ "$pull" == "true" ]]; then
    echo "$(date +%F:%T%:z) Pulling $image${platform:+ (platform=$platform)}"
    if [[ -n "$platform" ]]; then
        docker pull --platform "$platform" "$image"
    else
        docker pull "$image"
    fi
fi

echo "$(date +%F:%T%:z) Exporting $image${platform:+ (platform=$platform)}: $basename"

zipper=gzip
if command -v pigz >/dev/null 2>&1; then
    zipper="pigz -p 4"
fi

mkdir -p "$out_dir"
if [[ -n "$platform" ]]; then
    docker save --platform "$platform" "$image" | $zipper -c > "$out_dir/$basename".tgz.tmp
else
    docker save "$image" | $zipper -c > "$out_dir/$basename".tgz.tmp
fi
mv "$out_dir/$basename".tgz.tmp "$out_dir/$basename".tgz
echo "$(date +%F:%T%:z) Saved $image to $out_dir/$basename.tgz"

if [[ "$remove" == "true" ]]; then
    echo "$(date +%F:%T%:z) Removing image $image"
    docker rmi "$image" || true
fi

echo "$(date +%F:%T%:z) Done"
