docker_build:
	docker build -f Containerfile \
	  --network=host \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  -t local/alpine:3 ./

# --no-cache --build-arg build_region=cn --build-arg shell=/bin/bash
