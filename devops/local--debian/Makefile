docker_build:
	docker build -f Containerfile --no-cache -t local/debian:trixie-slim ./

# --no-cache
docker_build_proxy:
	docker build -f Containerfile \
	  --network=host \
	  --build-arg https_proxy=http://127.0.0.1:1080 \
	  --build-arg http_proxy=http://127.0.0.1:1080 \
	  -t local/debian:trixie-slim ./

# docker buildx du
# docker buildx prune
