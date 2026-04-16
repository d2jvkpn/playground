create_dirs:
	mkdir -p data/site-packages data/{config,cache,share,state} \
	  data/workspace/{custom_nodes,input,models,output,tmp}

docker_build:
	#docker build --no-cache -f Containerfile -t local/comfyui:cuda12.9-ubuntu24.04-base:$(shell date +%F) ./
	docker build -f Containerfile \
	  --network=host \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  -t q.local/comfyui:cuda12.9-base ./

docker_update:
	docker build --no-cache -f data/Containerfile.update \
	  --network=host \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  -t q.local/comfyui:cuda12.9-base ./

run:
	docker run -d --name=comfyui --gpus=all -p 8188:8188 q.local/comfyui:cuda12.9-base
