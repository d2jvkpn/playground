SHELL := /bin/bash

####
check:
	flake8 --exclude=cache,data,configs,examples --select=F --ignore=E,W,C

run:
	./gradio_app.py

dev:
	uvicorn --reload --host=127.0.0.1 --port=7860 main:app

prod:
	gunicorn -k uvicorn.workers.UvicornWorker --workers=1 --bind=127.0.0.1:7860 main:app

####
build:
	docker build --no-cache -f deploy/Containerfile -t local/gradio:latest ./

container:
	mkdir -p configs data logs && \
	docker run -d --name gradio -p 7860:7860 \
	    -v $(PWD)/configs:/opt/configs -v $(PWD)/data:/opt/data \
	    local/gradio:latest

compose:
	mkdir -p configs data logs && \
	cp deploy/compose.gradio.yaml compose.yaml
