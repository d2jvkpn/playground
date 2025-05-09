#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname $0`)

# https://askubuntu.com/questions/1502031/how-to-install-firefox-directly-from-mozilla-with-apt
# https://support.mozilla.org/en-US/kb/install-firefox-linux

#### 1. Create a directory to store APT repository keys if it doesn't exist:
sudo install -d -m 0755 /etc/apt/keyrings

#### 2. Import the Mozilla APT repository signing key:
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- |
  sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null

sudo apt-get install wget

#### 3. The fingerprint should be 35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3. See note below if this doesn't work.
gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc |
  awk '/pub/{getline; gsub(/^ +| +$/,""); print "\n"$0"\n"}'

#### 4. Next, add the Mozilla APT repository to your sources list:
echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" |
  sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null

#### 5. Configure APT to prioritize packages from the Mozilla repository:
echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | sudo tee /etc/apt/preferences.d/mozilla

#### 6. Update your package list and install the Firefox .deb package:
sudo apt-get update && sudo apt-get -y install firefox

exit

# Disable RDD Process
https://askubuntu.com/questions/1483112/high-cpu-usage-by-a-firefox-subprocess-called-rdd-process

on firefix goto URL     about:config
and search for          media.rdd

then double click on    media.rdd-process.enabled
to give it a value of   false
