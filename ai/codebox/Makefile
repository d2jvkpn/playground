container := $(shell yq .services.openclaw.container_name compose.yaml &> /dev/null || true)
#proxy ?= http://127.0.0.1:1080
proxy := ""

# make build_image build_args="--platform=linux/arm64 user_uid=501 user_gid=20"

.DEFAULT_GOAL := init

init:
	echo "proxy=$(proxy), build_args: $(build_args)"

create_dirs:
	mkdir -p data/apps data/workspace/configs data/workspace/logs \
	  data/config data/cache data/share data/state \
	  logs configs configs/sshd_config.d configs/ssh

create_share:
	mkdir -p data/share/claude data/share/codex data/share/pi data/share/omp data/share/agents

# make docker_build build_args="--no-cache"
# build_args := --no-cache
build_base:
	docker build $(build_args) -f Containerfile.base \
	  --network=host \
	  --build-arg https_proxy=$(proxy) \
	  --build-arg http_proxy=$(proxy) \
	  -t q.local/codebox:base ./

# make docker_build build_args="--no-cache"
# build_args := --no-cache
build_latest:
	docker build $(build_args) -f Containerfile.latest \
	  --network=host \
	  --build-arg https_proxy=$(proxy) \
	  --build-arg http_proxy=$(proxy) \
	  -t q.local/codebox:latest ./

tag_image:
	#docker tag q.local/codebox:latest q.local/codebox:$$(date +%Y.%-m.%-d)
	docker tag q.local/codebox:latest q.local/codebox:$$(date +%Y-%m-%d)

update_image:
	docker build -f data/Containerfile.update \
	  --network=host \
	  --build-arg https_proxy=$(proxy) \
	  --build-arg http_proxy=$(proxy) \
	  -t q.local/codebox:latest ./

root:
	docker exec -it -u root codebox bash

codebox:
	docker exec -it -u appuser -w /home/appuser/workspace $(container) bash

opencode:
	docker exec -it -u appuser -w /home/appuser/workspace $(container) bash
