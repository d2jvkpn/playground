#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


exit
apk --no-cache update
apk --no-cache add shadow

adduser -D -h /home/alpine -s /bin/bash -u 1000 alpine

addgroup -g 2025 alpine
usermod -u 2025 -g 2025 alpine

exit
# create a system user
addgroup -S appuser
adduser -S appuser -G appuser
