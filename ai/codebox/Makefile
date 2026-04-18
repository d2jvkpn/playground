create_dirs:
	mkdir -p data/apps data/workspace/configs data/workspace/logs \
	  data/config data/cache data/share data/state \
	  logs configs configs/sshd_config.d configs/ssh

docker_build:
	docker build --no-cache -f Containerfile \
	  --network=host \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  -t q.local/codebox:latest ./

docker_update:
	docker build --no-cache -f data/Containerfile.update \
	  --network=host \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  -t q.local/codebox:latest ./

root:
	docker exec -it -u root codebox bash

shell:
	docker exec -it -u appuser codebox bash

tmux:
	docker exec -it -u appuser codebox tmux
