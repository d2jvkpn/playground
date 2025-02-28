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
    py_venv=${1:-pyvenv.local}; py_venv=${py_venv%/}

    if [ ! -s $py_venv/bin/python3 ]; then
        echo "==> python3 -m venv $py_venv"
        python3 -m venv $py_venv
    fi
    source $py_venv/bin/activate
    export PY_VENV=$(readlink -f $py_venv)

    if [ -s $PY_VENV/pip.conf ]; then
        echo "--> found PIP_CONFIG_FILE: $PY_VENV/pip.conf"
        export PIP_CONFIG_FILE=$PY_VENV/pip.conf
    fi
    python3 --version
    # deactivate

    # pip3 install requests ipython pandas
    # pip3 freeze > requirements.txt
    # pip3 install -r requirements.txt
}
alias pyvenv.home='source ~/apps/pyvenv/bin/activate'

function ssh_no_hist() {
     local host="$1"
     ssh -t  "$host" 'HISTFILE="" bash --login'
}

function KubeLocal() {
    kubeconfig=${1:-./configs/kube.yaml}
    if [ ! -s "$kubeconfig" ]; then
        >&2 echo "config not found: $kubeconfig"
        return
    fi

   >&2 echo "+ export KUBECONFIG=$kubeconfig"
    export KUBECONFIG=$kubeconfig
}
