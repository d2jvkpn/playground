####
function docker_connect() {
    target=~/apps/$1.container
    [ -d "$target" ] || { >&2 echo "directory not found: $target"; exit 1; }
    cd "$target"
    make connect
}

function docker_up() {
    _wd=$(pwd)

    for d in "$@"; do
        target=~/apps/$d.container
        [ -d "$target" ] || { >&2 echo "directory not found: $target"; continue; }
        cd "$target"
        docker-compose up -d
    done

    cd ${_wd}
}

function docker_down() {
    _wd=$(pwd)

    for d in "$@"; do
        target=~/apps/$d.container
        [ -d "$target" ] || { >&2 echo "directory not found: $target"; continue; }
        cd "$target"
        docker-compose down
    done

    cd ${_wd}
}

function docker_restart() {
    _wd=$(pwd)

    target=~/apps/$d.container

    if [ ! -z "$target" ]; then
        cd $target
        docker-compose down
        docker-compose up -d
    fi

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
function x-pyvl() {
    py_venv=${1:-pyvenv.local}; py_venv=${py_venv%/}

    if [ ! -s $py_venv/bin/python3 ]; then
        #echo "==> python3 -m venv $py_venv"
        read -t 5 -p "Create venv $py_venv?(y/Y) " ans || true

        if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
            python3 -m venv $py_venv
        else
            echo -e '\nAbort!!!'
            return
        fi
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

alias x-pyvh='source ~/apps/pyvenv.home/bin/activate'

function x-ssh() {
     local host="$1"
     ssh -t  "$host" 'HISTFILE="" bash --login'
}

function x-kube() {
    kubeconfig=${1:-./configs/kube.yaml}
    if [ ! -s "$kubeconfig" ]; then
        >&2 echo "config not found: $kubeconfig"
        return
    fi

   >&2 echo "+ export KUBECONFIG=$kubeconfig"
    export KUBECONFIG=$kubeconfig
}
