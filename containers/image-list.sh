#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


mkdir -p images.local/public

for img in $(yq .public[].image image-list.yaml); do
    name=$(echo $img | sed 's#/#_#g; s#:#_#')
    filename=images.local/public/$name.tar

    if [ -s $filename.gz ]; then
        docker rmi $img || true
        continue
    fi

    echo "==> $img"
    docker pull $img
    docker save $img -o $filename
    pigz $filename
    docker rmi $img
done

exit
TODO: local
