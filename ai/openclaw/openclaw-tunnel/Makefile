docker_build:
	docker build --no-cache -f Containerfile \
	  --network=host \
	  --build-arg https_proxy="http://127.0.0.1:1080" \
	  --build-arg http_proxy="http://127.0.0.1:1080" \
	  -t local/openclaw-tunnel:latest ./

create_dirs:
	mkdir -p data/apps data/workspace/configs data/workspace/logs \
	  data/xdg/config data/xdg/cache data/xdg/share data/xdg/state \
	  data/openclaw configs logs

conn_appuser:
	docker exec -it -u appuser -w /home/appuser/.openclaw openclaw-tunnel bash
