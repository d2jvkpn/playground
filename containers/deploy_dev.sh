#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

# echo "Hello, world!"
cd ${_path}

cat > /dev/null <<'EOF'
preludes:
- todo
- todo

images:
- { name: app, tag: dev}
- { name: s1, tag: dev}

remote:
   host: host_a01
   dir: docker_dev/app_dev
EOF

[ -s configs/deploy_dev.yaml ] && {
     >&2 echo "file not exists: configs/deploy_dev.yaml";
     exit 1;
}

images=$(yq '.images | @tsv' configs/deploy_dev.yaml | awk 'NR>1{ print $1":"$2}')

remote_host=$(yq .remote.host configs/deploy_dev.yaml)
remote_dir=$(yq .remote.dir configs/deploy_dev.yaml)

#### local
case "$1" in
"local")
    for img in $images:    
        docker save $img -o image_$(echo $img | sed 's/:/_/g').tar;
    done

    ssh $remote_host mkdir -p $remote_dir
    rsync -arvP ./ $remote_host:$remote_dir

    ssh $remote_host bash $remote_dir/deploy_dev.sh remote
    ;;
"remote")
    for f in $(ls image_*.tar); do
        docker load -i $f
    done

    docker-compose up -d
    docker-compose ps
    ;;
*)
    >&2 echo "unknown argument"
    exit 1
    ;;
esac

# docker-compose pull
# docker images --filter "dangling=true" --quiet | xargs -i docker rmi {}
