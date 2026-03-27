create_dirs:
	mkdir -p data/apps data/workspace logs \
	  data/config data/cache data/share data/state \
	  data/openclaw

docker_build:
	docker build --no-cache -f Containerfile \
	  --network=host \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  -t local/openclaw:latest ./

docker_tag:
	bash tag_image.sh

docker_update:
	docker build --no-cache -f data/Containerfile.update \
	  --network=host \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  -t local/openclaw:latest ./

shell:
	docker exec -it -u appuser -w /home/appuser/.openclaw openclaw bash
