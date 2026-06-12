create_dirs:
	mkdir -p data/apps data/workspace/configs data/workspace/logs \
	  data/config data/cache data/share data/state \
	  logs configs configs/sshd_config.d configs/ssh

create_share:
	mkdir -p data/share/claude data/share/codex data/share/deepseek data/share/gemini

# make docker_build NO_CACHE=
NO_CACHE := --no-cache
docker_build:
	docker build $(NO_CACHE) -f Containerfile \
	  --network=host \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  -t q.local/codebox:latest ./

docker_tag:
	#docker tag q.local/codebox:latest q.local/codebox:$$(date +%Y.%-m.%-d)
	docker tag q.local/codebox:latest q.local/codebox:$$(date +%Y-%m-%d)

docker_update:
	docker build -f data/Containerfile.update \
	  --network=host \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  -t q.local/codebox:latest ./

root:
	docker exec -it -u root codebox bash

codebox:
	docker exec -it -u appuser -w /home/appuser/workspace codebox bash

opencode:
	docker exec -it -u appuser -w /home/appuser/workspace opencode bash
