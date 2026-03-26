docker_build:
	docker build -f Containerfile \
	  --no-cache --network=host \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg no_proxy="" \
	  -t local/python:3 ./
