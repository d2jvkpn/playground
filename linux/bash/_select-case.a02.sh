#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


clear

PS3="Please select an option: "
options=("Opt1" "Opt2" "Exit")

select choice in "${options[@]}"; do
    case $choice in
    "Opt1")
        echo "==> Opt1"
        ;;
    "Opt2")
        echo "==> Opt2"
        ;;
    "Exit")
        echo "<== Exit"
        break
        ;;
    *)
        echo "<== Invalid Option"
        break
        ;;
    esac
done
