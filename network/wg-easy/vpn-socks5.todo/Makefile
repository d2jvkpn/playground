image:
	docker build --no-cache -f Containerfile -t local/vpn-socks5:dev ./

image-cn:
	docker build --no-cache -f Containerfile \
	  --build-arg=region="cn" \
	  -t local/vpn-socks5:dev ./
