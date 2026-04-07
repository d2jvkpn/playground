create_dirs:
	mkdir -p data/apps data/workspace/configs data/workspace/logs \
	  data/config data/cache data/share data/state

docker_build:
	docker build --no-cache -f Containerfile \
	  --network=host \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  -t local/claude-code:latest ./

shell:
	docker exec -it -u appuser claude-code bash

claude:
	docker exec -it -u appuser claude-code claude

tmux:
	docker exec -it -u appuser claude-code tmux
