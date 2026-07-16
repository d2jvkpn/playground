user_gid ?= 1000
user_uid ?= 1000

container := $(shell yq .services.pyjs.container_name compose.yaml)

create_dirs:
	mkdir -p data/apps data/workspace data/site-packages \
	  data/config data/cache data/share data/state

# make docker_build NO_CACHE=
NO_CACHE := --no-cache
build_image:
	docker build $(NO_CACHE) -f Containerfile \
	  --network=host \
	  --build-arg user_gid=$(user_gid) \
	  --build-arg user_uid=$(user_uid) \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  -t q.local/pyjs:trixie ./

update_image:
	docker build --no-cache -f data/Containerfile.update \
	  --network=host \
	  --build-arg user_gid=$(user_gid) \
	  --build-arg user_uid=$(user_uid) \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  -t q.local/pyjs:trixie ./

root:
	docker exec -it -u root -w /home/appuser/workspace $(container) bash

shell:
	docker exec -it -u appuser -w /home/appuser/workspace $(container) bash
