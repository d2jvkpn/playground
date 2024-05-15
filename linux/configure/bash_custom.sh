####
function docker_connect() {
    target=~/Work/docker/$1
    [ -d "$target" ] || { >&2 echo "directory not found: $target"; exit 1; }
    cd "$target"
    make connect
}

function docker_up() {
    target=~/Work/docker/$1
    [ -d "$target" ] || { >&2 echo "directory not found: $target"; exit 1; }
    cd "$target"
    docker-compose up -d
}
