#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0) # set -x

host=$1

runlike=${runlike:-.local/bin/runlike}
# docker run --rm -v /var/run/docker.sock:/var/run/docker.sock assaflavie/runlike

out_dir=runlike_$(date +%F)
mkdir -p $out_dir

containers=$(ssh $host docker ps | awk 'NR>1{print $NF}')

for container in $containers; do
    echo "==> container: $container"
    ssh $host $runlike -p $container > $out_dir/$container.runlike.sh
done

####
exit
pip3 install runlike
pip3 install whaler

docker ps | awk 'NR>1{print $NF}' | xargs -i runlike {}

exit
mkdir configs
ln -sr company.docker-aliyun.json configs/config.json

docker --config ./configs pull your_image

####
exit
docker ps |
  awk 'NR>1{print $NF}' |
  xargs -i docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  assaflavie/runlike {}

docker run -t --rm -v /var/run/docker.sock:/var/run/docker.sock:ro pegleg/whaler \
  -sV=1.36 nginx:latest
