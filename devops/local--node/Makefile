user_gid ?= 1000
user_uid ?= 1000

docker_build:
	# --no-cache --build-arg build_region=cn
	docker build -f Containerfile \
	  --network=host \
	  --build-arg user_gid=$(user_gid) \
	  --build-arg user_uid=$(user_uid) \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  -t local/node:24-trixie ./
