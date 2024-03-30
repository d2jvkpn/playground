#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

#### 1. backup configs
ls data/backups
grep backup_path config/gitlab.rb
tar -czf $(date +"%s_%F")_gitlab_config.tgz config


#### 2. backup data
# docker exec -it gitlab_app bash
# docker exec gitlab_app gitlab-ctl stop
# docker exec gitlab_app gitlab-rake gitlab:backup:create STRATEGY=copy
docker exec gitlab_app gitlab-backup create STRATEGY=copy

docker exec gitlab_app ls -lart /var/opt/gitlab/backups
ls backups

docker exec gitlab_app gitlab-ctl start

#### 3. run server and stop
# tar -xf xxxx_gitlab_config.tgz -C config/
docker exec gitlab_app gitlab-ctl reconfigure
docker exec gitlab_app gitlab-ctl start
docker exec gitlab_app gitlab-ctl stop unicorn
docker exec gitlab_app gitlab-ctl stop sidekiq
docker exec gitlab_app gitlab-ctl status
docker exec gitlab_app ls -lart /var/opt/gitlab/backups


#### 4. restore from backup
mv config/gitlab-secrets.json config/gitlab-secrets.bk.json
cp gitlab-secrets.json config/
chmod a+r data/backups/*_gitlab_backup.tar
docker exec gitlab_app gitlab-rake gitlab:backup:restore --trace
#additional parameter: BACKUP=1537738690_2018_09_23_10.8.3 --trace

docker exec gitlab_app gitlab-ctl restart
#or docker exec -it gitlab_app gitlab-rake gitlab:check SANITIZE=true

docker ps gitlab_app
