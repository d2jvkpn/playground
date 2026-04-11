#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


#### install gog
tag_name=$(curl -fsSL https://api.github.com/repos/steipete/gogcli/releases/latest | jq -r .tag_name)
curl -fL -o gogcli.tar.gz "https://github.com/steipete/gogcli/releases/download/$tag_name/gogcli_${tag_name#v}_linux_amd64.tar.gz"
tar -xf gogcli.tar.gz -C /usr/local/bin/ gog
chmod a+x /usr/local/bin/gog
rm -rf gogcli.tar.gz

#### install mongosh
curl -fsSL https://pgp.mongodb.com/server-8.0.asc | \
  gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor

echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/debian bookworm/mongodb-org/8.0 main" | \
  tee /etc/apt/sources.list.d/mongodb-org-8.0.list

apt-get update
apt-get install -y mongodb-mongosh

#### apt install
bash /opt/scripts/apt_install.sh at sqlite3 postgresql-client mariadb-client-compat

#### install himalaya
#curl -sSL https://raw.githubusercontent.com/pimalaya/himalaya/master/install.sh | sh

#tag_name=$(curl -fsSL https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | jq -r .tag_name)
#curl -fL -o obsidian.deb https://github.com/obsidianmd/obsidian-releases/releases/download/$tag_name/obsidian_${tag_name#v}_amd64.deb
#apt install -y ./obsidian.deb
#rm -rf obsidian.deb
