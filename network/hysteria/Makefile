docker_build:
	docker build --no-cache -f Containerfile -t local/hysteria:latest ./

docker_build_proxy:
	docker build --no-cache -f Containerfile \
	  --build-arg https_proxy="$https_proxy" -t local/hysteria:latest ./

docker_archive:
	mkdir -p data
	docker save local/hysteria:latest | gzip -c > data/local--hysteria--latest.tar.gz
