#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


systemctl disable ubuntu-advantage
pro config set apt_news=false

fp=/usr/lib/update-notifier/apt_check.py
if [[ -s $fp && ! -s $fp.bk ]]; then
    cp $fp $fp.bk

    sed -Ezi.orig \
      -e 's/(def _output_esm_service_status.outstream, have_esm_service, service_type.:\n)/\1    return\n/' \
      -e 's/(def _output_esm_package_alert.*?\n.*?\n.:\n)/\1    return\n/' \
      $fp
fi

fp=/usr/lib/update-notifier/update-motd-updates-available
if [[ -s $fp ]]; then
 $fp --force
fi

fp=/var/lib/ubuntu-advantage/apt-esm/etc/apt/sources.list.d/ubuntu-esm-apps.list
[ -s $fp ] && sudo sed -i '/^deb/s/^/#-- /' $fp

#### ??? How to disable esm-apps notification
# /var/lib/ubuntu-advantage/apt-esm/etc/apt/sources.list.d/ubuntu-esm-apps.sources
# /usr/share/keyrings/ubuntu-pro-esm-apps.gpg

if [ -s /etc/default/motd-news ]; then
   sudo sed -i '/ENABLED/s/1/0/' /etc/default/motd-news
fi
#- sudo sed -i '/=motd.dynamic/s/^/#-- /' /etc/pam.d/sshd

####
for f in /etc/update-motd.d/80-esm \
    /etc/update-motd.d/80-livepatch \
    /etc/update-motd.d/90-updates-available; do
    [ -s $f ] && sudo chmod -x $f
done
# ls /etc/update-motd.d/*

####
#sudo apt remove landscape-common
#sudo apt remove update-notifier-common
