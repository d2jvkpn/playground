docker_build:
	docker build -f Containerfile \
	  --network=host \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  -t local/openclaw:latest ./

create_dirs:
	mkdir -p data/openclaw data/apps data/xdg/config data/xdg/cache data/xdg/share data/xdg/state
