#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

smb_addr=//192.168.1.42/shareFile
mount_point=/mnt/smba/bob

echo "==> samba address: smb:$smb_addr"
mkdir -p $mount_point ~/.samba

cat > ~/.samba/bob.credential << EOF
username=bob
password=123456
EOF

mount -t cifs \
  -o ro,file_mode=0777,dir_mode=0777 \
  -o iocharset=utf8,vers=3.0 \
  -o credentials=~/.samba/bob.credential \
  $smb_addr $mount_point
