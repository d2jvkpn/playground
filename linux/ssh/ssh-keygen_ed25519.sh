#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

comment=${comment:-}
name=$1


ssh-keygen -t ed25519 -m PEM -N "" -C "$comment" -f "$name.ssh-ed25519"
ssh-keygen -y -f "$name".ssh-ed25519 > "$name.ssh-ed25519.pub"

touch "$name.known_hosts"

exit
cat > "$name.conf" <<EOF
Host host
	#ProxyJump     jump_host
	#ProxyCommand  nc -X 5 -x 127.0.0.1:1080 %h %p
	HostName      127.0.0.1
	User          root
	Port          22
	IdentityFile  /path/to/"$name".ssh-ed25519
	UserKnownHostsFile /path/to/"$name".known_hosts
	LogLevel      INFO
	Compression   yes
	ServerAliveInterval 15
	#RemoteCommand HISTFILE='' bash --login
	#RequestTTY yes
EOF
