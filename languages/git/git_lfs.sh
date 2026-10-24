#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

exit
sudo apt update
sudo apt install git git-lfs
git lfs install

git clone https://huggingface.co/BAAI/bge-m3

# without lfs
# GIT_LFS_SKIP_SMUDGE=1 git clone <repo_url>

# disable lfs
#git config --global lfs.fetchinclude ""
#git config --global lfs.fetchexclude "*"

#### recover
#git config --unset --global lfs.fetchinclude
#git config --unset --global lfs.fetchexclude


# pull without lfs
GIT_LFS_SKIP_SMUDGE=1 git pull
cat .gitattributes
git lfs ls-files

ls ~/.git/lfs/objects/

git config lfs.url https://your-lfs-server.com/path
git config lfs.contenttype false

git add .gitattributes
git commit -m "Track large files with Git LFS"

git lfs track "*.psd"
git lfs track "*.zip"
git lfs track "data/*.bin"

git add file.psd
git commit -m "Add large file"
git push origin main

git lfs pull
git lfs env
git lfs fetch
git lfs status
git lfs prune
git lfs uninstall


#### MinIO
# 下载 MinIO 二进制文件
wget https://dl.min.io/server/minio/release/linux-amd64/minio
chmod +x minio
sudo mv minio /usr/local/bin/

# 启动 MinIO（数据存储在 ~/minio-data）
minio server ~/minio-data --console-address ":9001"

git config lfs.http://localhost:9000/git-lfs.access basic
git config lfs.http://localhost:9000/git-lfs.user ACCESS_KEY
git config lfs.http://localhost:9000/git-lfs.password SECRET_KEY

#### gitea
cat <<EOF
# app.ini
[lfs]
ENABLED = true
PATH = /var/lib/gitea/lfs
EOF

#### nginx
mkdir -p /var/www/git-lfs
chmod -R 777 /var/www/git-lfs

cat > /etc/nginx/sites-available/git-lfs <<EOF
server {
    listen 80;
    server_name your-server.com;

    location /git-lfs/ {
        root /var/www;
        client_max_body_size 500M;
        dav_methods PUT DELETE;
        create_full_put_path on;
        dav_access user:rw group:rw all:r;
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/git-lfs /etc/nginx/sites-enabled/
sudo systemctl restart nginx

git config lfs.url "http://your-server.com/git-lfs"
