#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

####
python3 -m venv cache/local.venv

source cache/local.venv/bin/activate

pip3 install -r requirements.txt

exit
####
export config=configs/local.yaml

uvicorn main:app --reload --host=127.0.0.1 --port=5000

celery -A tasks worker --loglevel=info --concurrency=2

exit
####
curl -X POST "http://127.0.0.1:5000/upload" -F "file=@data/demo.pdf"

curl -X GET "http://127.0.0.1:5000/task/de406724-e254-406c-92ad-441696035a09"
