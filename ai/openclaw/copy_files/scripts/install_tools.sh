#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


####
bash /opt/scripts/apt_install.sh at gh sqlite3 postgresql-client mariadb-client-compat

####
tag_name=$(curl -fsSL https://api.github.com/repos/steipete/gogcli/releases/latest | jq -r .tag_name)
curl -fL -o gogcli.tar.gz "https://github.com/steipete/gogcli/releases/download/$tag_name/gogcli_${tag_name#v}_linux_amd64.tar.gz"
tar -xf gogcli.tar.gz -C /usr/local/bin/ gog
chmod a+x /usr/local/bin/gog
rm -rf gogcli.tar.gz

#curl -sSL https://raw.githubusercontent.com/pimalaya/himalaya/master/install.sh | sh

#tag_name=$(curl -fsSL https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | jq -r .tag_name)
#curl -fL -o obsidian.deb https://github.com/obsidianmd/obsidian-releases/releases/download/$tag_name/obsidian_${tag_name#v}_amd64.deb
#apt install -y ./obsidian.deb
#rm -rf obsidian.deb
