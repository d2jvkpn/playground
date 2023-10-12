#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

container=gaussian-splatting_$(tr -dc '0-9a-z' < /dev/urandom | fold -w 8 | head -n 1 || true)

# docker build -f Dockerfile -t gaussian-splatting ./
docker run -d --name $container --gpus=all nvidia/cuda:11.7.1-devel-ubuntu22.04 tail -f /etc/hosts

## not working:
# docker run -tid --name gaussian-splatting --gpus=all nvidia/cuda:12.2.0-devel-ubuntu22.04 bash

docker exec $container mkdir -p /opt/bin

docker cp ./app_build.sh $container:/opt/app_build.sh
docker cp ./conda_app.sh $container:/opt/bin/conda_app.sh

docker exec $container chmod a+x /opt/bin/conda_app.sh
docker exec $container bash /opt/app_build.sh

# docker commit -p --change='ENTRYPOINT ["/entrypoint.sh"]' $container gaussian-splatting:latest
docker commit -p \
  --change='ENV TZ=Asia/Shanghai' \
  --change='ENV CONDA_DIR=/opt/conda' \
  --change='ENV PATH=/opt/bin:$CONDA_DIR/bin:$PATH' \
  --change='ENV PATH=/opt/gaussian-splatting/SIBR_viewers/install/bin:$PATH' \
  --change='WORKDIR /opt/gaussian-splatting' \
  $container gaussian-splatting:latest

docker stop $container && docker rm $container

exit
docker save gaussian-splatting:latest -o gaussian-splatting_latest.tar
pigz gaussian-splatting_latest.tar

docker run --rm -it --gpus=all gaussian-splatting:latest bash

conda init bash
exec bash
conda activate gaussian_splatting
