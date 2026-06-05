#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
docker ps -f status=exited -q | xargs -I{} docker rm {}
docker images --filter "dangling=true" --quiet | xargs -I{} docker rmi {}

exit
#docker system prune -a
docker system prune
docker system df

docker builder prune
