# image = local/jupyter:pytorch2.8.0-cuda12.9-cudnn9-runtime
image = $(shell awk -F '[ :]' '/FROM/{print "local/jupyter:pytorch"$$NF}' Containerfile)

echo:
	echo user_uid=$(shell id -u), user_gid=$(shell id -g), image=$(image)

build:
	docker build -f Containerfile --no-cache -t $(image) ./

root_gpu:
	mkdir -p configs data/pip_packages logs
	docker run -d --restart=always --name=jupyter --hostname=jupyter  --gpus=all \
	  -p 8888:8888 \
	  -w /root/work \
	  -v $(shell pwd):/root/work \
	  -v $(shell pwd)/data/pip_packages:/root/.local/lib/python3.11/site-packages \
	  --env-file=configs/container.env \
	  $(image)

appuser_gpu:
	mkdir -p configs data/pip_packages logs
	docker run -d --restart=always --name=jupyter --hostname=jupyter --gpus=all \
	  -p 8888:8888 \
	  -w /home/appuser/work \
	  -v $(shell pwd):/home/appuser/work \
	  -v $(shell pwd)/data/pip_packages:/home/appuser/.local/lib/python3.11/site-packages \
	  --env-file=configs/container.env \
	  -e USER_UID=$(shell id -u) -e USER_GID=$(shell id -g) \
	  $(image)

root_cpu:
	mkdir -p configs data/pip_packages logs
	docker run -d --restart=always --name=jupyter --hostname=jupyter \
	  -p 8888:8888 \
	  -w /root/work \
	  -v $(shell pwd):/root/work \
	  -v $(shell pwd)/data/pip_packages:/root/.local/lib/python3.11/site-packages \
	  --env-file=configs/container.env \
	  $(image)

# -v $(pwd)/apps/pip.conf:/root/.config/pip/pip.conf
# -v $(pwd)/apps/ipython_config.py:/root/.ipython/profile_default/ipython_config.py
# -e PYTHONPATH=/root/work/data/pip_packages:/opt/conda/lib/python3.11/site-packages

appuser_cpu:
	mkdir -p configs data/pip_packages logs
	docker run -d --restart=always --name=jupyter --hostname=jupyter \
	  -p 8888:8888 \
	  -w /home/appuser/work \
	  -v $(shell pwd):/home/appuser/work \
	  -v $(shell pwd)/data/pip_packages:/home/appuser/.local/lib/python3.11/site-packages \
	  --env-file=configs/container.env \
	  -e USER_UID=$(shell id -u) -e USER_GID=$(shell id -g) \
	  $(image)
