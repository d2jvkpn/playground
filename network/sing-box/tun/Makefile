sing_box_version = 1.13.3

docker_build:
	docker build --no-cache -f Containerfile \
	  --network=host \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  --build-arg sing_box_version=$(sing_box_version) \
	  -t local/sing-box:latest ./
	docker tag local/sing-box:latest local/sing-box:v$(sing_box_version)
