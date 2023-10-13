_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

conda init bash
exec bash
conda activate gaussian_splatting
