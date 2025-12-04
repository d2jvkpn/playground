build:
	docker build --no-cache -f Containerfile -t local/comfyui:$(shell date +%F) ./

run:
	docker run -d --name=comfyui --gpus=all -p 8188:8188 local/comfyui:latest
