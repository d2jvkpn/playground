build:
	#docker build --no-cache -f Containerfile -t local/comfyui-base:cuda12.8-ubuntu24.04:$(shell date +%F) ./
	docker build --no-cache -f Containerfile \
	  --build-arg HTTP_PROXY="$PROXY_ADDR" \
	  --build-arg HTTPS_PROXY="$PROXY_ADDR" \
	  -t local/comfyui-base:cuda12.8-ubuntu24.04 ./

update:
	docker build --no-cache -f Containerfile.update \
	  --build-arg HTTP_PROXY="$PROXY_ADDR" \
	  --build-arg HTTPS_PROXY="$PROXY_ADDR" \
	  -t local/comfyui-base:cuda12.8-ubuntu24.04 ./

run:
	docker run -d --name=comfyui --gpus=all -p 8188:8188 local/comfyui:latest
