#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

####
if [ ! -d "cache/local.venv" ]; then
    python3 -m venv cache/local.venv
    pip3 install -r requirements.txt
fi

mkdir -p logs data/uploads
source cache/local.venv/bin/activate


exit
####
export config=configs/local.yaml

uvicorn main:app --reload --log-config=logging_config.yaml --host=127.0.0.1 --port=5000

celery -A tasks worker --loglevel=info --logfile=logs/celery.log --concurrency=1
#  --log-format="[%(asctime)s] [%(levelname)s] %(processName)s - %(message)s" \
#  --task-log-format="[%(asctime)s] [%(levelname)s] [%(task_name)s(%(task_id)s)] - %(message)s"
