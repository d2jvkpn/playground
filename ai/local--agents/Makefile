user_gid ?= 1000
user_uid ?= 1000

create_dirs:
	mkdir -p data/apps data/workspace/configs data/workspace/logs \
	  data/xdg/config data/xdg/cache data/xdg/share data/xdg/state \
	  data/site-packages configs logs

# docker build args: --build-arg build_region=cn
docker_build:
	docker build --no-cache -f Containerfile \
	  --network=host \
	  --build-arg user_gid=$(user_gid) \
	  --build-arg user_uid=$(user_uid) \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  -t local/agents:24-trixie ./
