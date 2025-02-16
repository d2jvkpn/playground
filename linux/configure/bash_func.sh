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
function pyvenv_local() {
    if [ ! -s pyvenv.local/bin/python3 ]; then
        echo "==> python3 -m venv pyvenv.local"
        python3 -m venv pyvenv.local
    fi
    source pyvenv.local/bin/activate
    export PY_VENV=$PWD/pyvenv.local

    if [ -s $PWD/pyvenv.local/pip.conf ]; then
        echo "--> found PIP_CONFIG_FILE: pyvenv.local/pip.conf"
        export PIP_CONFIG_FILE=$PWD/pyvenv.local/pip.conf
    fi
    python3 --version
    # deactivate

    # pip3 install requests ipython pandas
    # pip3 freeze > requirements.txt
    # pip3 install -r requirements.txt
}
alias pyvenv_home='source ~/apps/pyvenv/bin/activate'

function ssh_no_hist() {
     local host="$1"
     ssh -t  "$host" 'HISTFILE="" bash --login'
}
