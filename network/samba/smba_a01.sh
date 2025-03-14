#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

smb_addr=//192.168.1.42/project
username=bob
password=123456

####
mount_point=/mnt/samba/$(basename $smb_addr)
cred_file=~/.config/samba/${username}-$(echo $smb_addr | awk -F "/" '{print $3}').conf

echo "==> smb_addr: $smb_addr, mount_point: $mount_point, cred_file: $cred_file"

sudo mkdir -p $mount_point
sudo chown -R `whoami` $mount_point
sudo chmod 700 $mount_point

if [ ! -s $cred_file ]; then
    mkdir -p $(dirname $cred_file)
cat > $cred_file << EOF
username=$username
password=$password
EOF
# chmod 600 $cred_file
fi

####
sudo mount -t cifs \
  -o ro,file_mode=0777,dir_mode=0777,vers=3.0 \
  -o iocharset=utf8,credentials=$cred_file \
  $smb_addr $mount_point

ls -alt $mount_point

exit
sudo umount $mount_point

exit
sudo mount -t cifs //192.168.1.42/project /mnt/samba/project \
  -o username=bob,password=123456,vers=3.0,sec=ntlmssp

exit
echo "$smb_addr $mount_point cifs credentials=$cred_file,uid=1000,gid=1000 0 0" >> /etc/fstab
