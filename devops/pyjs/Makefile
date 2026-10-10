PUID ?= 1000
PGID ?= 1000

# docker run --privileged --rm tonistiigi/binfmt --install arm64

# make build_image args="--platform=linux/amd64 --no-cache"
# make build_image args="--platform=linux/arm64"

container := $(shell yq .services.pyjs.container_name compose.yaml &> /dev/null || true)
#proxy ?= http://127.0.0.1:1080
proxy := ""

build_args := --no-cache
# build_args

.DEFAULT_GOAL := init

init:
	echo "PUID: $(PUID), PGID: $(PGID), proxy=$(proxy), build_args: $(build_args)"

create_dirs:
	mkdir -p data/apps data/workspace data/site-packages \
	  data/config data/cache data/share data/state

# make docker_build build_args="" proxy=
build_image:
	docker build $(build_args) -f Containerfile \
	  --network=host \
	  --build-arg PGID=$(PGID) \
	  --build-arg PUID=$(PUID) \
	  --build-arg https_proxy=$(proxy) \
	  --build-arg http_proxy=$(proxy) \
	  -t q.local/pyjs:trixie ./

update_image:
	docker build $(build_args) -f data/Containerfile.update \
	  --network=host \
	  --build-arg PGID=$(PGID) \
	  --build-arg PUID=$(PUID) \
	  --build-arg https_proxy=$(proxy) \
	  --build-arg http_proxy=$(proxy) \
	  -t q.local/pyjs:trixie ./

root:
	docker exec -it -u root -w /home/appuser/workspace $(container) bash

shell:
	docker exec -it -u appuser -w /home/appuser/workspace $(container) bash
