docker_build:
	docker build --no-cache -f Containerfile \
	    --network=host \
	  --build-arg https_proxy=http://127.0.0.1:1080 \
	  -t q.local/hysteria:latest ./

docker_tag:
	bash tag_image.sh
