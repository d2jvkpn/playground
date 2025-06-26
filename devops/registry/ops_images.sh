#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


registry_addr=localhost:5000


docker tag registry:3 $registry_addr/public/registry:3

docker login $registry_addr
# > Username: 
# > Password: 

docker push $registry_addr/public/registry:3
#docker pull $registry_addr/public/registry:3
