#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit

ls -l /etc/update-motd.d/

sudo chmod -x /etc/update-motd.d/90-updates-available
sudo chmod -x /etc/update-motd.d/91-release-upgrade
sudo chmod -x /etc/update-motd.d/92-unattended-upgrades

sudo sed -i 's/^ENABLED=.*/ENABLED=0/' /etc/default/motd-news

# sudo nano /etc/motd
