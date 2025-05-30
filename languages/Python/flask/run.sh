#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


gunicorn -w 4 -b 0.0.0.0:5000 flask_server:app
