container := $(shell yq .services.openclaw.container_name compose.yaml)

create_dirs:
	mkdir -p data/apps data/site-packages data/workspace/configs data/workspace/logs \
	  data/config data/cache data/share data/state \
	  data/agents data/openclaw

# make docker_build NO_CACHE=
NO_CACHE := --no-cache
docker_build:
	docker build $(NO_CACHE) -f Containerfile \
	  --network=host \
	  --build-arg openclaw_version=latest \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  -t q.local/openclaw:latest ./

docker_update:
	docker build --no-cache -f data/Containerfile.update \
	  --network=host \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  -t q.local/openclaw:latest ./

docker_tag:
	bash tag_image.sh

root:
	docker exec -it -u root -w /home/appuser/workspace $(container) bash

shell:
	docker exec -it -u appuser -w /home/appuser/.openclaw $(container) bash

up:
	docker compose up -d

down:
	docker compose down

get_token:
	jq -r '.gateway.auth.token' data/openclaw/openclaw.json
