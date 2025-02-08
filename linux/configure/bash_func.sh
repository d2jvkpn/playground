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

####
function pyvenv() {
    if [ ! -s venv.local/bin/python3 ]; then
        echo "==> python3 -m venv venv.local"
        python3 -m venv venv.local
    fi
    # ls venv

    source venv.local/bin/activate
    python3 --version
    export PY_VENV=$PWD/venv.local

    # export PIP_CONFIG_FILE=$PWD/venv.local/pip.conf
    # deactivate

    # pip3 install requests ipython pandas
    # pip3 freeze > requirements.txt
    # pip3 install -r requirements.txt
}

alias pyvenv-local='source ~/apps/pyvenv/bin/activate'
