#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit

sudo apt install bash_completion

ls /usr/share/bash-completion/bash_completion
ls /usr/share/bash-completion/completions/
ls /etc/bash_completion.d/
