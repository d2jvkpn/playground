build_image:
	docker build --no-cache -f Containerfile \
	  --network=host \
	  --build-arg https_proxy=http://127.0.0.1:1080 \
	  --build-arg http_proxy=http://127.0.0.1:1080 \
	  -t q.local/hysteria:latest ./

tag_image:
	bash tag_image.sh
