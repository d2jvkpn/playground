user_gid ?= 1000
user_uid ?= 1000

create_dirs:
	mkdir -p data/apps data/workspace data/site-packages \
	  data/config datacache data/share data/state

docker_build:
	docker build --no-cache -f Containerfile \
	  --network=host \
	  --build-arg user_gid=$(user_gid) \
	  --build-arg user_uid=$(user_uid) \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  -t local/pyjs:trixie ./

docker_update:
	docker build --no-cache -f data/Containerfile.update \
	  --network=host \
	  --build-arg user_gid=$(user_gid) \
	  --build-arg user_uid=$(user_uid) \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  -t local/pyjs:trixie ./
