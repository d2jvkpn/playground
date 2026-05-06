#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

dry_run=${dry_run:-"false"}

name=q.local/openclaw

mkdir -p data

cid=$(docker create $name:latest)
docker cp "$cid:/home/appuser/.local/npm/lib/node_modules/openclaw/package.json" data/openclaw.package.json
docker rm "$cid"

version=$(jq -r .version data/openclaw.package.json | awk -F '-' '{print $1}')
if [[ "$dry_run" == "true" ]]; then
    echo "version: $version"
    exit 0
fi

docker tag $name:latest $name:$version
echo "$name:$version"
