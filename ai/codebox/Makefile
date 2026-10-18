container := $(shell yq .services.openclaw.container_name compose.yaml &> /dev/null || true)
#proxy ?= http://127.0.0.1:1080
proxy := ""
platform := "amd64" # arm64

# make build_image args="--platform=linux/amd64 --no-cache"
# make build_image args="--platform=linux/arm64"

.DEFAULT_GOAL := init

init:
	echo "Args: proxy=$(proxy), build_args: $(build_args)"

create-dirs:
	mkdir -p data/apps data/workspace/configs data/workspace/logs \
	  data/config data/cache data/share data/state \
	  logs configs configs/sshd_config.d configs/ssh

# make build-image build_args="--no-cache"
# build_args := --no-cache
build-image:
	docker build $(build_args) -f Containerfile \
	  --network=host \
	  --build-arg https_proxy=$(proxy) \
	  --build-arg http_proxy=$(proxy) \
	  --platform=linux/$(platform) \
	  -t q.local/codebox:$(platform)-latest ./

tag-image:
	#docker tag q.local/codebox:latest q.local/codebox:$$(date +%Y.%-m.%-d)
	docker tag q.local/codebox:$(platform)-latest q.local/codebox:$(platform)-$$(date +%Y-%m-%d)

update-image:
	docker build -f data/Containerfile.update \
	  --network=host \
	  --build-arg https_proxy=$(proxy) \
	  --build-arg http_proxy=$(proxy) \
	  --platform=linux/$(platform) \
	  -t q.local/codebox:$(platform)-latest ./

root:
	docker exec -it -u root codebox bash

codebox:
	docker exec -it -u appuser -w /home/appuser/workspace $(container) bash

opencode:
	docker exec -it -u appuser -w /home/appuser/workspace $(container) bash
