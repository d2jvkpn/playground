#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

supervisorctl reread
supervisorctl update
supervisorctl start <app>
supervisorctl status
