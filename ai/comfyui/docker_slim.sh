#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


#### 1.
mkdir -p data

docker create --name comfyui-tmp local/comfyui-base:cuda12.8-ubuntu24.04
# docker run --name comfyui-tmp -it local/comfyui-base:cuda12.8-ubuntu24.04 /bin/sh

docker export comfyui-tmp | docker import - local/comfyui-base:tmp
# docker import --change 'WORKDIR /app' --change 'ENV NODE_ENV=production' --change 'CMD ["node","server.js"]' rootfs.tar your-slim-image:tag

docker rm comfyui-tmp

#### 2.
docker image inspect local/comfyui-base:cuda12.8-ubuntu24.04 --format '{{json .Config}}' | jq -r '
  def q: @json;
  "FROM local/comfyui-base:tmp",
  (if .WorkingDir and .WorkingDir != "" then "WORKDIR " + .WorkingDir else empty end),
  (if .User and .User != "" then "USER " + .User else empty end),
  (.Env[]? | "ENV " + .),
  (if .Labels then (.Labels|to_entries[]? | "LABEL " + .key + "=" + (.value|q)) else empty end),
  (if .ExposedPorts then (.ExposedPorts|keys[]? | "EXPOSE " + .) else empty end),
  (if .Volumes then (.Volumes|keys[]? | "VOLUME " + .) else empty end),
  (if .StopSignal and .StopSignal != "" then "STOPSIGNAL " + .StopSignal else empty end),
  (if .Entrypoint then "ENTRYPOINT " + (.Entrypoint|q) else empty end),
  (if .Cmd then "CMD " + (.Cmd|q) else empty end)
' > data/Containerfile.tmp

docker build -f data/Containerfile.tmp -t local/comfyui-base:cuda12.8-ubuntu24.04 ./
rm data/Containerfile.tmp

docker rmi local/comfyui-base:tmp

exit
docker save local/comfyui-base:cuda12.8-ubuntu24.04 |
  pigz -p4 > data/local--comfyui-base--cuda12.8-ubuntu24.04.tgz
