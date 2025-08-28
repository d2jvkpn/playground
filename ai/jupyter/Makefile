image = local/jupyter:pytorch2.8.0-cuda12.9-cudnn9-runtime

build:
	docker build -f Containerfile --no-cache -t $(image) ./

run_gpu:
	mkdir -p configs data logs
	docker run -d --restart=always --gpus=all \
	  --name=jupyter --hostname=jupyter \
	  -p 8888:8888 \
	  -v $(shell pwd):/root/work \
	  --env-file=configs/container.env \
	  -w /root/work \
	  $(image)

run_gpu_appuser:
	mkdir -p configs data logs
	docker run -d --restart=always \
	  --name=jupyter --hostname=jupyter \
	  -p 8888:8888 \
	  -v $(shell pwd):/home/appuser/work \
	  --env-file=configs/container.env \
	  -e USER_UID=$UID -e USER_GID=$UID \
	  -w /home/appuser/work \
	  $(image)

run_cpu:
	mkdir -p configs data logs
	docker run -d --restart=always \
	  --name=jupyter --hostname=jupyter \
	  -p 8888:8888 \
	  -v $(shell pwd):/root/work \
	  --env-file=configs/container.env \
	  -w /root/work \
	  $(image)

# -v $(pwd)/apps/pip.conf:/root/.config/pip/pip.conf
# -v $(pwd)/apps/ipython_config.py:/root/.ipython/profile_default/ipython_config.py
# -e PYTHONPATH=/root/work/data/pip_packages:/opt/conda/lib/python3.11/site-packages


run_cpu_appuser:
	mkdir -p configs data logs
	docker run -d --restart=always \
	  --name=jupyter --hostname=jupyter \
	  -p 8888:8888 \
	  -v $(shell pwd):/home/appuser/work \
	  --env-file=configs/container.env \
	  -e USER_UID=$UID -e USER_GID=$UID \
	  -w /home/appuser/work \
	  $(image)
