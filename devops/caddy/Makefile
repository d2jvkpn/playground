proxy := ""

build_image:
	docker build -f Containerfile \
	  --network=host \
	  --build-arg https_proxy=$(proxy) \
	  --build-arg http_proxy=$(proxy) \
	  -t q.local/caddy:2 ./

reload:
	docker exec caddy caddy validate --config /etc/caddy/Caddyfile && \
	docker exec caddy caddy reload --config /etc/caddy/Caddyfile
