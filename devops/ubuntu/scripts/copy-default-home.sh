#!/bin/sh
set -eu

docker exec -u root ubuntu sh -c '
    chown ubuntu:ubuntu /home/ubuntu
    cp -an /opt/defaults/ubuntu/. /home/ubuntu/
'
echo 'Copied missing default files to /home/ubuntu'
