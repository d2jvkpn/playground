#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)/
_path=$(dirname $0)/

####
docker pull mysql:8
docker pull ubuntu:20.04

docker build -t atlassian ./

docker network create atlassian


####
docker-compose up -d

docker cp db.sql atlassian_mysql:/db.sql
docker exec atlassian_mysql bash -c "mysql -u root -h localhost -p12345678 < /db.sql"

docker exec -it atlassian_apps bash

cmd="""
####
./atlassian-jira-software-8.17.1-x64.bin

/opt/atlassian/jira/bin/shutdown.sh

cp mysql-connector-java-8.0.27/mysql-connector-java-8.0.27.jar /opt/atlassian/jira/lib/

/opt/atlassian/jira/bin/start-jira.sh

####
./atlassian-confluence-7.13.1-x64.bin

/opt/atlassian/confluence/bin/shutdown.sh

cp mysql-connector-java-8.0.27/mysql-connector-java-8.0.27.jar /opt/atlassian/jira/lib/

/opt/atlassian/confluence/bin/start-confluence.sh

rm ./atlassian-jira-software-8.17.1-x64.bin ./atlassian-confluence-7.13.1-x64.bin
rm -f mysql-connector-java-8.0.27*
"""

exit
jira: http://localhost:4000
confluence: http://localhost:4002
