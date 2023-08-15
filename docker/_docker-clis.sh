#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

#### prune images and containers
docker ps -f status=exited -q | xargs -i docker rm {}
docker images -f dangling=true -q | xargs -i docker rmi {}

for img in $(docker images --filter "dangling=true" --quiet $image); do
    docker rmi $img || true
done &> /dev/null

#### get ip address of container
docker ps -q |
  xargs docker inspect --format "{{.Name}}  {{.NetworkSettings.IPAddress}}" |
  sed '1i Name IPAddress' |
  column -t -s'  '

#### backup images
mkdir docker_images

for img $(docker images | awk '!/none/ && NR>1{print $1":"$2}'); do
    out=$(basename $img | sed 's#:#_#')
    docker save img -o docker_images/$out
    pigz docker_images/$out
done
