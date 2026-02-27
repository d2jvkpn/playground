#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname $0`)

pipx install ipython runlike ansible jupyterlab

# sydo apt install python3-pip python3-ipython ipython3
# python3 -m venv ~/apps/pyvenv
# source ~/apps/pyvenv/bin/activate
# pip install requests numpy pandas polar scikit-learn pyyaml

#### 2. commandlines
cat <<EOF
apps:
- docker-compose: https://github.com/docker/compose/releases
- yq: https://github.com/mikefarah/yq/releases
- tokei: cargo install tokei
- bat: cargo install bat
- eza: cargo install eza
- rg: cargo install ripgrep
- xsv: cargo install xsv
- dufs: cargo install dufs
- yt-dlp: https://github.com/yt-dlp/yt-dlp
- nushell: https://www.nushell.sh/book/installation.html
```bash
#### debian
curl -fsSL https://apt.fury.io/nushell/gpg.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/fury-nushell.gpg
echo "deb https://apt.fury.io/nushell/ /" | sudo tee /etc/apt/sources.list.d/fury.list
sudo apt update
sudo apt install nushell

#### alpine
echo "https://alpine.fury.io/nushell/" | tee -a /etc/apk/repositories
apk update
apk add --allow-untrusted nushell

#### cargo
cargo install nu --locked
```
EOF

#### 3. desktop apps
cat <<EOF
apps:
- firefox, addons=[Orbit, Privacy Badger]
- librewolf
- LocalSend, urls=[https://localsend.org/, https://github.com/localsend/localsend/releases]
EOF

#### 3. alt
cat <<EOF
- protoc-gen-go
- htop
- glances
EOF
