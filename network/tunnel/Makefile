sing_box_version = 1.13.3

create_dirs:
	mkdir -p data/xdg/config data/xdg/cache data/xdg/share data/xdg/state \
	  data/apps data/workspace configs logs

docker_build:
	docker build --no-cache -f Containerfile \
	  --network=host \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  --build-arg sing_box_version=$(sing_box_version) \
	  -t local/tunnel:latest ./
