include configs/local.env
SHELL := /bin/bash
config = "./configs/local.yaml"

#### python
check:
	. ${PY_VENV}/bin/activate && \
	flake8 --exclude=cache,data,configs,examples --select=F --ignore=E,W,C
