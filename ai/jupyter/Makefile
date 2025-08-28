build:
	docker build -f Containerfile --no-cache \
	  -t local/jupyter:pytorch2.8.0-cuda12.9-cudnn9-runtime \
	  ./

run:
	mkdir -p configs data logs
	docker run -d --restart=always --gpus=all \
	  --name=jupyter --hostname=jupyter \
	  -p 8888:8888 \
	  -v $(shell pwd):/root/work \
	  --env-file=configs/container.env \
	  local/jupyter:pytorch2.8.0-cuda12.9-cudnn9-runtime
