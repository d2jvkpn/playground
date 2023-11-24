#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

####
pip3 install ansible

####
cat > ansible.cfg <<EOF
[defaults]
inventory = ./configs/hosts.ini
# private_key_file = /path/to/private_key
# roles_path = /path/to/roles
EOF

####
ansible kvm -i ./configs/hosts.ini --one-line -m ping

####
ansible kvm --one-line -m shell -a 'echo "Hello, world!"'

ansible kvm -m shell --become -a "dpkg -l | awk '/^rc/{print \$2}' | xargs -i dpkg -P {}"

####
mkdir -p wk_data/hello
echo "Hello, world!" > wk_data/hello/hello.txt
ansible kvm --one-line -m copy -a "src=./wk_data/hello dest=./"
ansible kvm --one-line -m file -a "path=./hello state=absent"
