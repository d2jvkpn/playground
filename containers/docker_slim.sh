#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


image=$1
image_name=$(echo $image | awk -F ":" 'NR==1{print $1}')
container=$(basename $image_name)-temp

#### 1.
mkdir -p data

docker image inspect $image --format '{{json .Config}}' | jq -r '
  def q: @json;
  "FROM '${image}-temp'",
  (if .WorkingDir and .WorkingDir != "" then "WORKDIR " + .WorkingDir else empty end),
  (if .User and .User != "" then "USER " + .User else empty end),
  (.Env[]? | "ENV " + .),
  (if .Labels then (.Labels|to_entries[]? | "LABEL " + .key + "=" + (.value|q)) else empty end),
  (if .ExposedPorts then (.ExposedPorts|keys[]? | "EXPOSE " + .) else empty end),
  (if .Volumes then (.Volumes|keys[]? | "VOLUME " + .) else empty end),
  (if .StopSignal and .StopSignal != "" then "STOPSIGNAL " + .StopSignal else empty end),
  (if .Entrypoint then "ENTRYPOINT " + (.Entrypoint|q) else empty end),
  (if .Cmd then "CMD " + (.Cmd|q) else empty end)
' > data/Containerfile.temp

echo "--> Containerfile: data/Containerfile.temp"

echo "--> Creating container: $container"
docker create --name $container $image
# docker run --name --entrypoint="" $container -it $image /bin/sh
# < execute cleanup comandlines

echo "--> Creating image: ${image}-temp"
docker export $container | docker import - ${image}-temp
# docker import --change 'WORKDIR /app' --change 'ENV NODE_ENV=production' --change 'CMD ["node","server.js"]' rootfs.tar your-slim-image:tag

docker rm -f $container

#### 2.
docker build -f data/Containerfile.temp -t ${image}-slim ./

rm data/Containerfile.temp
docker rmi ${image}-temp

exit
docker save ${image}-slim | pigz -p4 > $(echo ${image}-slim | sed 's#/#--#g; s#:#--#').tgz
