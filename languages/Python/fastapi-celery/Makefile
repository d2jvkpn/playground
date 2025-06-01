SHELL := /bin/bash

fastapi:
	. cache/local.venv/bin/activate && \
	  uvicorn main:app --reload --log-config=logging_config.yaml --host=127.0.0.1 --port=5000

celery:
	mkdir -p logs
	. cache/local.venv/bin/activate && \
	  celery -A tasks worker --loglevel=info --logfile=logs/celery.log --concurrency=1

test-create:
	mkdir -p data
	echo "Hello, world! 20205" > data/test.txt
	curl -X POST "http://127.0.0.1:5000/task/create" -F "file=@data/test.txt" > data/test.response.json

test-status:
	curl -X GET "http://127.0.0.1:5000/task/status?task_id=$$(jq -r .task_id data/test.response.json)"
