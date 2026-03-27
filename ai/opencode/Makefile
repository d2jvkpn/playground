create_dirs:
	mkdir -p data/apps data/workspace \
	  data/config data/cache data/share data/state \
	  data/gemini data/codex

docker_build:
	docker build -f Containerfile \
	  --no-cache --network=host \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  -t local/opencode:latest ./

docker_tag:
	version=$(shell docker run --rm -it local/opencode:latest opencode --version) && \
	docker tag local/opencode:latest local/opencode:$$version

docker_update:
	docker build --no-cache -f data/Containerfile.update \
	  --network=host \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  -t local/opencode:latest ./

shell:
	docker exec --it opencode bash
