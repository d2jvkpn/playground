#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname $0`)

# https://librewolf.net/installation/debian/

sudo apt update && sudo apt install -y extrepo

sudo extrepo enable librewolf

sudo apt update && sudo apt install -y librewolf

exit
sudo rm -f \
  /etc/apt/sources.list.d/librewolf.sources \
  /etc/apt/keyrings/librewolf.gpg \
  /etc/apt/preferences.d/librewolf.pref \
  /etc/apt/sources.list.d/home_bgstack15_aftermozilla.sources \
  /etc/apt/keyrings/home_bgstack15_aftermozilla.gpg \
  /etc/apt/sources.list.d/librewolf.list \
  /etc/apt/trusted.gpg.d/librewolf.gpg \
  /etc/apt/sources.list.d/home:bgstack15:aftermozilla.list \
  /etc/apt/trusted.gpg.d/home_bgstack15_aftermozilla.gpg
