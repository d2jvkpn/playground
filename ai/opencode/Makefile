create_dirs:
	mkdir -p data/apps data/workspace \
	  data/xdg/config data/xdg/cache data/xdg/share data/xdg/state \
	  data/gemini 

docker_build:
	docker build --no-cache -f Containerfile \
	  --network=host \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  -t local/opencode:latest ./

docker_tag:
	version=$(shell docker run --rm -it local/opencode:latest opencode --version) && \
	docker tag local/opencode:latest local/opencode:$$version

docker_build_update:
	docker build --no-cache -f data/Containerfile.update \
	  --network=host \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  -t local/opencode:latest ./
