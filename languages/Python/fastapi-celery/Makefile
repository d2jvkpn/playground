#!/usr/bin/make

SHELL := /bin/bash

config = "./configs/local.yaml"

init:
	echo "==> config: $(config)"
	mkdir -p logs data/uploads
	if [ ! -d "cache/local.venv" ]; then \
	  python3 -m venv cache/local.venv; \
	  pip3 install -r requirements.txt; \
	fi
	mkdir -p logs data/uploads

fastapi:
	. cache/local.venv/bin/activate && \
	uvicorn server:app --reload --log-config=logging_config.yaml --host=127.0.0.1 --port=5000

celery:
	. cache/local.venv/bin/activate && \
	celery -A tasks worker --loglevel=info --logfile=logs/celery.log --concurrency=1
	#  --log-format="[%(asctime)s] [%(levelname)s] %(processName)s - %(message)s" \
	#  --task-log-format="[%(asctime)s] [%(levelname)s] [%(task_name)s(%(task_id)s)] - %(message)s"

flower:
	. cache/local.venv/bin/activate && \
	celery -A tasks flower --port=5555

test-create:
	echo "Hello, world! 20205" > data/test.txt
	curl -X POST "http://127.0.0.1:5000/task/create" -F "file=@data/test.txt" | tee data/test.response.json

test-status:
	curl -X GET "http://127.0.0.1:5000/task/status?task_id=$$(jq -r .data.task_id data/test.response.json)"
