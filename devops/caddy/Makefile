build_image:
	docker build -f Containerfile \
	  --network=host \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  -t q.local/caddy:2 ./

reload:
	docker exec caddy caddy validate --config /etc/caddy/Caddyfile
	docker exec caddy caddy reload --config /etc/caddy/Caddyfile
