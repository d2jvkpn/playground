build:
	#docker build --no-cache -f Containerfile -t local/comfyui:cuda12.9-ubuntu24.04-base:$(shell date +%F) ./
	docker build -f Containerfile \
	  --build-arg HTTPS_PROXY="$HTTPS_PROXY" \
	  -t local/comfyui:cuda12.9-base ./

update:
	docker build --no-cache -f Containerfile.update \
	  --build-arg HTTPS_PROXY="$HTTPS_PROXY" \
	  -t local/comfyui:cuda12.9-base ./

run:
	docker run -d --name=comfyui --gpus=all -p 8188:8188 local/comfyui:cuda12.9-base
