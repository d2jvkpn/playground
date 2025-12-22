#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
# export GIT_LFS_SKIP_SMUDGE=1
GIT_LFS_SKIP_SMUDGE=1 git clone --depth=1 https://huggingface.co/GiantAILab/YingMusic-SVC

cd <repo>
git lfs pull --include="bs_roformer.ckpt"


exit
pip install -U "huggingface_hub[cli]"

# https://huggingface.co/GiantAILab/YingMusic-SVC

hf download --local-dir ./models/GiantAILab/YingMusic-SVC GiantAILab/YingMusic-SVC

hf download --local-dir ./models/GiantAILab/YingMusic-SVC GiantAILab/YingMusic-SVC YingMusic-SVC-full.pt
