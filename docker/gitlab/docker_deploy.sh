#!/bin/bash
set -eu -o pipefail

export HTTP_Port=$1 SSH_Port=$2 DOMAIN=$3 HOME=$HOME

# gitlab work path: $HOME/docker_prod/gitlab
# nginx work path: $HOME/nginx

####
envsub < nginx_gitlab.tmpl> $HOME/nginx/configs/nginx_gitlab.conf
nginx -t && nginx -s reload

####
mkdir -p $HOME/docker_prod/gitlab/{configs,data,logs}
##!! not https:://
# cp ./config/gitlab.rb ./config/gitlab.rb.bk
# echo -e "\nexternal_url \"http://$DOMAIN\"" >> ./config/gitlab.rb

envsubst < docker_deploy.yaml > docker-compose.yaml
docker-compose pull
docker-compose up -d

docker logs -f gitlab_app

#### get init admin(root) password
docker exec -it gitlab_app grep 'Password:' /etc/gitlab/initial_root_password
# gitlab-rake "gitlab:password:reset"

####
# echo -e '\nexternal_url "http://gitlab.example.com"' >> $HOME/docker_prod/gitlab/config/gitlab.rb
# docker exec gitlab_app bash -c "gitlab-ctl reconfigure && gitlab-ctl restart"
# docker-compose restart
