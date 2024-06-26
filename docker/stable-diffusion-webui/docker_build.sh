#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

SD_Version=${1:-1.8.0}

#### 1. image tag p1-${SD_Version}
# convert 00000-170371915.png -resize 128x128 01.png
# echo '{"init_images": ["'"$(base64 -w0 01.png)"'"]}' > data_img2img.json
# echo '{"image": "'"$(base64 -w0 01.png)"'", "model": "clip"}' > data_clip.json
ls Dockerfile http_data/{clip.json,img2img.json} bin/{entrypoint.sh,install.sh} > /dev/null

docker pull ubuntu:22.04
docker build --no-cache --build-arg=SD_Version="$SD_Version" -t sd-webui:p1-$SD_Version  ./
# docker history sd-webui:p1-$SD_Version

#### 2. image tag ${SD_Version}
port=7860
addr=http://127.0.0.1:$port

mkdir -p data/models data/extentions/sd-webui-controlnet data/cache data/interrogate

#  -v $PWD/data/models:/app/sd-webui/models \
#  -v $PWD/data/extentions/sd-webui-controlnet:/app/sd-webui/extensions/sd-webui-controlnet/annotator/downloads \
#  -v $PWD/data/interrogate:/app/sd-webui/interrogate \
#  -v $PWD/data/cache:/root/.cache \

docker run -d --name sd-webui --gpus=all -p 127.0.0.1:$port:7860 \
  sd-webui:p1-$SD_Version \
  /app/bin/entrypoint.sh --xformers --listen --api --port=7860

echo "==> Waiting SD service $addr to launch on ..."
n=1
while ! curl --output /dev/null --silent --head --fail $addr; do
    sleep 1 && echo -n .
    [ $((n%60)) -eq 0 ] && echo ""
    n=$((n+1))

    if [[ "$(docker container inspect -f '{{.State.Running}}' sd-webui)" != "true" ]]; then
        >&2 echo "container isn't running"
        exit 1
    fi
done
echo ""
echo "==> SD Service $addr launched"

#### 3. trigger downloads by calling apis
curl $addr/sdapi/v1/txt2img --silent -H "Content-Type: application/json" \
  -d '{"prompt": "a wooden house"}' --output /dev/null

curl $addr/sdapi/v1/img2img --silent -H "Content-Type: application/json" \
  -d @http_data/img2img.json --output /dev/null

curl $addr/sdapi/v1/interrogate --silent -H "Content-Type: application/json" \
  -d @http_data/clip.json --output /dev/null

## TODO: ControlNet download: extensions/sd-webui-controlnet/annotator/downloads

#### 4. copy models from container
# mkdir -p data
# docker copy sd-webui:/app/sd-webui/models ./data/models
# docker copy sd-webui:/app/.cache ./data/cache
# docker copy sd-webui:/app/sd-webui/extensions/sd-webui-controlnet/annotator/downloads ./data/extensions/sd-webui-controlnet
# docker copy sd-webui:/app/sd-webui/interrogate ./data/interrogate

#### 5. clean up and save the image
docker exec sd-webui bash \
  -c 'rm -r models/BLIP/*.pth models/Stable-diffusion/*.safetensors ~/.cache/pip'

docker commit -p sd-webui sd-webui:${SD_Version}
docker stop sd-webui && docker rm sd-webui
exit

docker save sd-webui:${SD_Version} -o sd-webui_${SD_Version}.tar
pigz sd-webui_${SD_Version}.tar
