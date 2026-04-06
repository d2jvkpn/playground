docker_build:
	docker build --no-cache -f Containerfile \
	    --network=host \
	  --build-arg https_proxy=http://127.0.0.1:1080 \
	  -t local/hysteria:latest ./

docker_tag:
	bash tag_image.sh

docker_archive:
	mkdir -p data
	docker save local/hysteria:latest | gzip -c > data/local--hysteria--latest.tar.gz
