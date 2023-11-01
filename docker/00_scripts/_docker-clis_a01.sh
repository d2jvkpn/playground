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

#### misc
docker images --digests
docker inspect registry.k8s.io/ingress-nginx/controller:v1.8.1 | jq -r '.[0].RepoDigests[0]'

## pull lastest images
# yq -r ".services | .[] | .image" docker-compose.yaml | xargs -i docker pull {}
docker-compose pull
docker-compose up -d
docker-compose up -d service-{01..03}
docker-compose down

yq -r ".services | keys" docker-compose.yaml
yq -r ".services | keys[]" docker-compose.yaml

#### get ip address of mysql_service
docker inspect mysql_service | jq -r ".[0].NetworkSettings.IPAddress"
mysql -u root -h ${IP} -p
