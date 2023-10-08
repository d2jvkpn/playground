#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

SD_Version=${1:-1.6.0}

#### p1-${SD_Version}
# convert 00000-170371915.png -resize 128x128 01.png
# echo '{"init_images": ["'"$(base64 -w0 01.png)"'"]}' > data_img2img.json
# echo '{"image": "'"$(base64 -w0 01.png)"'", "model": "clip"}' > data_clip.json
ls data_clip.json data_img2img.json Dockerfile entrypoint.sh > /dev/null

docker pull ubuntu:22.04

docker build --no-cache --build-arg=SD_Version="$SD_Version" -t sd-webui:p1-$SD_Version  ./
# docker history stable-diffusion-webui:$SD_Version

#### p2-${SD_Version}
port=7860
addr=http://127.0.0.1:$port

docker run -d --name sd-webui --gpus=all -p 127.0.0.1:$port:7860 \
  sd-webui:p1-$SD_Version /entrypoint.sh --xformers --listen --api --port=7860

echo "==> Waiting SD service $addr to launch on ..."
while ! curl --output /dev/null --silent --head --fail $addr; do
    sleep 1 && echo -n .
done
echo ""
echo "==> SD Service $addr launched"

# trigger downloads by calling apis
curl $addr/sdapi/v1/txt2img --silent -H "Content-Type: application/json" \
  -d '{"prompt": "a wooden house"}' --output /dev/null

curl $addr/sdapi/v1/img2img --silent -H "Content-Type: application/json" \
  -d @data_img2img.json --output /dev/null

curl $addr/sdapi/v1/interrogate --silent -H "Content-Type: application/json" \
  -d @data_clip.json --output /dev/null

# TODO: ControlNet download: extensions/sd-webui-controlnet/annotator/downloads

# copy models from container
docker exec sd-webui ls /home/hello/.cache \
  /home/hello/stable-diffusion-webui/{models,extensions,interrogate,repositories}

# docker copy sd-webui:/home/hello/stable-diffusion-webui/models ./

docker exec sd-webui bash -c \
  'rm -r models/BLIP/*.pth models/Stable-diffusion/*.safetensors ~/.cache/pip'

docker commit -p sd-webui sd-webui:${SD_Version}
docker stop sd-webui && docker rm sd-webui
# docker images sd-webui
