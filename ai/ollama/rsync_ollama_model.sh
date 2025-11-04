#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


model_id=$1    # "qwen3-vl:4b"
#remote_uri=$2 # remote_host:path/to/ollama
remote_host=$2 # remote_host
remote_dir=$3  # path/to/ollama_dir

model_lib=$(ls models/manifests/registry.ollama.ai/*/$(echo $model_id | sed 's#:#/#'))
echo "$(date +%FT%T%:z) ==> model_lib: $model_lib"
# rsync -arvP $model_lib $remote_uri/$model_lib

blobs=$(
for f in $(jq -r ".config.digest, .layers[].digest" $model_lib | sed 's/:/-/'); do
    f=models/blobs/$f
    ls $f
done
)

ssh $remote_host mkdir -p $remote_dir/$(dirname $model_lib)

for f in $model_lib $blobs; do
    echo "--> file: $model_lib"
    rsync -arvP $f $remote_host:$remote_dir/$f
done

echo "$(date +%FT%T%:z) <== done"
