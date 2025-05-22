#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


# doc: https://dev.to/johndotowl/postgresql-17-installation-on-ubuntu-2404-5bfi

# First, update the package index and install required packages:
sudo apt update

# Add the PostgreSQL 17 repository:
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/postgres.list'

# Import the repository signing key:
curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc |
  sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg

# Update the package list:
sudo apt update


sudo apt install postgresql-client-17


exit
# Install PostgreSQL 17 and contrib modules:
sudo apt install postgresql-17

sudo systemctl start postgresql
sudo systemctl enable postgresql
