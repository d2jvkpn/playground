#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# export TZ=Asia/Shanghai
# export CONDA_DIR=/opt/conda
# export PATH=/opt/bin:$CONDA_DIR/bin:$PATH
# export PATH=/opt/gaussian-splatting/SIBR_viewers/install/bin:$PATH

conda init bash
exec bash
conda activate gaussian_splatting

echo "==> conda: CONDA_DEFAULT_ENV=$CONDA_DEFAULT_ENV, CONDA_PREFIX=$CONDA_PREFIX"
exec "$@"
