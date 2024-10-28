#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

bk_dir=gitlab.$(date +%F).bk
mkdir -p $bk_dir

#### 1. backup configs
ls data/backups
grep backup_path config/gitlab.rb
tar -czf $bk_dir/config.tgz config


#### 2. backup data
# docker exec -it gitlab bash
# docker exec gitlab gitlab-ctl stop
# docker exec gitlab gitlab-rake gitlab:backup:create STRATEGY=copy
docker exec gitlab gitlab-backup create STRATEGY=copy

bk_file=$(ls -t data/backups/*_gitlab_backup.tar)
echo "==> gitlab backup file: $bk_file"

mv $bk_file $bk_dir/
ls -alh $bk_dir

# docker exec gitlab ls -lart /var/opt/gitlab/backups
# ls backups

docker exec gitlab gitlab-ctl start

#### 3. run server and stop
# tar -xf xxxx_gitlab_config.tgz -C config/
docker exec gitlab gitlab-ctl reconfigure
docker exec gitlab gitlab-ctl start
docker exec gitlab gitlab-ctl stop unicorn
docker exec gitlab gitlab-ctl stop sidekiq
docker exec gitlab gitlab-ctl status
docker exec gitlab ls -lart /var/opt/gitlab/backups


#### 4. restore from backup
mv config/gitlab-secrets.json config/gitlab-secrets.bk.json
cp gitlab-secrets.json config/
chmod a+r data/backups/*_gitlab_backup.tar
docker exec gitlab gitlab-rake gitlab:backup:restore --trace
#additional parameter: BACKUP=1537738690_2018_09_23_10.8.3 --trace

docker exec gitlab gitlab-ctl restart
#or docker exec -it gitlab gitlab-rake gitlab:check SANITIZE=true

docker ps gitlab
