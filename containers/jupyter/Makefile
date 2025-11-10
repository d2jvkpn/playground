# image = local/jupyter:pytorch2.8.0-cuda12.9-cudnn9-runtime
image = $(shell awk -F '[ :]' '/^FROM/{ sub("^local/", "", $$NF); print "local/jupyter:pytorch"$$NF; exit }' Containerfile)
py = python3.12

echo:
	echo user_uid=$(shell id -u), user_gid=$(shell id -g), image=$(image)

build:
	docker build -f Containerfile --no-cache -t $(image) ./

appuser_gpu:
	mkdir -p configs data/pip logs
	docker run -d --restart=always --name=jupyter --hostname=jupyter --gpus=all \
	  -p 8888:8888 \
	  -v $(shell pwd):/home/appuser/workspace \
	  -v $(shell pwd)/data/pip:/home/appuser/.local/lib/$(py)/site-packages \
	  --env-file=configs/container.env \
	  -e USER_UID=$(shell id -u) -e USER_GID=$(shell id -g) \
	  -w /home/appuser/workspace \
	  $(image)

appuser_cpu:
	mkdir -p configs data/pip logs
	docker run -d --restart=always --name=jupyter --hostname=jupyter \
	  -p 8888:8888 \
	  -v $(shell pwd):/home/appuser/workspace \
	  -v $(shell pwd)/data/pip:/home/appuser/.local/lib/$(py)/site-packages \
	  --env-file=configs/container.env \
	  -e USER_UID=$(shell id -u) -e USER_GID=$(shell id -g) \
	  -w /home/appuser/workspace \
	  $(image)
