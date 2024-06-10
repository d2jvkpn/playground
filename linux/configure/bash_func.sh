####
function docker_connect() {
    target=~/Work/docker/$1
    [ -d "$target" ] || { >&2 echo "directory not found: $target"; exit 1; }
    cd "$target"
    make connect
}

function docker_up() {
    _wd=$(pwd)

    for d in "$@"; do
        target=~/Work/docker/$d
        [ -d "$target" ] || { >&2 echo "directory not found: $target"; continue; }
        cd "$target"
        docker-compose up -d
    done

    cd ${_wd}
}

function docker_down() {
    _wd=$(pwd)

    for d in "$@"; do
        target=~/Work/docker/$d
        [ -d "$target" ] || { >&2 echo "directory not found: $target"; continue; }
        cd "$target"
        docker-compose down
    done

    cd ${_wd}
}

function docker_pull() {
    remote_host=$1
    image=$2

    base=$(basename $image | sed 's/:/_/g')
    set -x

    ssh $remote_host "docker pull $image; docker save $image -o $base.tar; pigz $base.tar"
    rsync -arvP $remote_host:$base.tar.gz /tmp/

    pigz -dc /tmp/$base.tar.gz | docker load

    ssh $remote_host "rm $base.tar.gz; docker rmi $image || true"
    rm /tmp/$base.tar.gz
    docker images --quiet --filter "dangling=true" ${image%:*} | xargs -i docker rmi {} || true

    set +x
}

####
function go_lint() {
    go mod tidy
    if [ -d vendor ]; then go mod vendor; fi
    go fmt ./...
    go vet ./...
}

####
function git_root() {
    wd=""

    while true; do
        d=$(pwd)
        # echo "==> $d, $wd"
        [[ "$wd" == "$d" || -d "$d/.git" ]] && break
        wd="$d"
        cd ../
    done
}
