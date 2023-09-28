#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

#### ubuntu 22.04
sudo systemctl disable ubuntu-advantage
sudo pro config set apt_news=false

sudo cp /usr/lib/update-notifier/apt_check.py /usr/lib/update-notifier/apt_check.py.bk

sudo sed -Ezi.orig \
  -e 's/(def _output_esm_service_status.outstream, have_esm_service, service_type.:\n)/\1    return\n/' \
  -e 's/(def _output_esm_package_alert.*?\n.*?\n.:\n)/\1    return\n/' \
  /usr/lib/update-notifier/apt_check.py

sudo /usr/lib/update-notifier/update-motd-updates-available --force

sudo sed -i '/^deb/s/^/#-- /' /var/lib/ubuntu-advantage/apt-esm/etc/apt/sources.list.d/ubuntu-esm-apps.list

sudo sed -i '/ENABLED/s/1/0/' /etc/default/motd-news
#- sudo sed -i '/=motd.dynamic/s/^/#-- /' /etc/pam.d/sshd

####
exit
sudo apt install landscape-common
landscape-sysinfo
