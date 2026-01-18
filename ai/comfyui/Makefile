build:
	#docker build --no-cache -f Containerfile -t local/comfyui:cuda12.9-ubuntu24.04-base:$(shell date +%F) ./
	docker build -f Containerfile \
	  --build-arg HTTPS_PROXY="$PROXY_ADDR" \
	  --build-arg HTTP_PROXY="$PROXY_ADDR" \
	  -t local/comfyui:cuda12.9-ubuntu24.04-base ./

update:
	docker build --no-cache -f Containerfile.update \
	  --build-arg HTTPS_PROXY="$PROXY_ADDR" \
	  --build-arg HTTP_PROXY="$PROXY_ADDR" \
	  -t local/comfyui:cuda12.9-ubuntu24.04--base ./

run:
	docker run -d --name=comfyui --gpus=all -p 8188:8188 local/comfyui:cuda12.9-ubuntu24.04-base
