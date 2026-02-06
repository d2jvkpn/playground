docker_build:
	docker build --no-cache -f Containerfile -t local/hysteria:latest ./
	mkdir -p data
	docker save local/hysteria:latest | gzip -c > data/local--hysteria--latest.tar.gz
