#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


ssh remote_host docker save image:tag | pigz > image--tag.tar.gz
