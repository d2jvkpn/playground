####
function with_proxy() {
    if [ -z "$https_proxy" ]; then
        _addr=socks5h://127.0.0.1:1080
        echo "Set https_proxy to $_addr"
        export https_proxy=$_addr
    else
        echo "Unset https_proxy"
        unset https_proxy
    fi
}

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

function docker_sh() {
    container=$1

    if [ $# -gt 1 ]; then
        docker exec $@
    else
        docker exec -it $container bash || docker exec -it container sh
    fi
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
function venv() {
    #venv_path=cache/local.venv
    venv_path=.venv

    if [ ! -s $venv_path/bin/python3 ]; then
        #echo "==> python3 -m venv $venv_path"
        read -t 5 -p "Create python venv $venv_path?(yes/no) " ans || true

        if [[ "$ans" != "yes" ]]; then
            echo -e '\nAbort!!!'
            return
        fi
        python3 -m venv $venv_path
    fi

    source $venv_path/bin/activate

    if [ -s configs/pip.conf ]; then
        echo "--> found PIP_CONFIG_FILE: configs/pip.conf"
        export PIP_CONFIG_FILE=configs/pip.conf
    fi
    python3 --version
    # deactivate

    # pip3 install requests ipython pandas
    # pip3 freeze > requirements.txt
    # pip3 install -r requirements.txt
}

#alias venv-home='source ~/apps/home.venv/bin/activate'
function venv-home() {
    target=${1:-home}

    source ~/apps/"${target}".venv/bin/activate
}

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

    #>&2 echo "+ export KUBECONFIG=$kubeconfig"
    export KUBECONFIG=$kubeconfig

    yaml=$(kubectl config view --minify)
    current=$(echo "$yaml" | yq .current-context)
    context=$(echo "$yaml" | yq '.contexts.[] | select(.name == "'$current'")')
    cluster=$(echo "$context" | yq .context.cluster)
    server=$(echo "$yaml" | yq '.clusters.[] | select(.name == "'$cluster'") | .cluster.server')

    echo "config: $kubeconfig"
    echo "server: $server"
    echo "$context"
}
