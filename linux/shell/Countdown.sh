#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

if [[ $# -eq 0 || "$1" == *"-h"* ]]; then
    echo "$(basename $0) [timeout] [command] [args...]"
    echo -e "e.g.\n    timeout: 5s, 1m\n    Countdown.sh 15s mpv ~/Downloads/sounds/01.wav"
    exit 0
fi

dur=$1
shift
cmd="$*"

####
if [ $# -eq 0 ]; then
    if [ ! -f ~/.config/Countdown/default.sh ]; then
        >&2 echo "no command(s) and ~/.config/Countdown/default.sh provided!"
        exit 1
    else
        cmd="bash ~/.config/Countdown/default.sh"
    fi
fi

if [[ ! "$dur" =~ ^[0-9]+(|m|s)$ ]]; then
    echo "invalid time interval" >&2
    exit 1
elif [[ "$dur" == *"s" ]]; then
    secs=${dur%s}
elif [[ "$dur" == *"m" ]]; then
    secs=$((${dur%m} * 60))
fi

date +"==> %FT%T%:z: $dur $cmd"

####
sp='|/-\'
j=0

for i in $(seq 1 $secs | tac); do
    c=${sp:j++%${#sp}:1}
    echo -en "\r$c $(date +%FT%T%:z) $(printf "%03d" $i)"
    sleep 1
done

echo -e "\r= $(date +%FT%T:%:z) END\n"
eval $cmd

exit

cat > ~/.config/Countdown/default.sh <<EOF
mpv ${_path}/sounds/01.wav
EOF
