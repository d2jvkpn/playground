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
