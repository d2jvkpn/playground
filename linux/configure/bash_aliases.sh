# path: ~/apps/bash_bash_aliases
# $: ln -sr ~/apps/bash_bash_aliases ~/.bash_aliases

####
export HISTTIMEFORMAT="%Y-%m-%dT%H:%M:%S%z "
# %Y-%m-%dT%H:%M:%S%:z doesn't work as expected
export PROMPT_DIRTRIM=2

export PATH=~/.local/bin:$PATH
for d in $(ls -d ~/apps/*/ /opt/*/ 2> /dev/null); do
    d=${d%/}
    b=$(basename $d)
    [ "${b:0:1}" == "_" ] && continue
    [ -d $d/bin ] && d=$d/bin
    [ -r $d ] || continue
    export PATH=$d:$PATH
done

####
alias tree1='tree -L 1'
alias tree2='tree -L 2'
alias tree3='tree -L 3'
alias tree4='tree -L 4'
alias tree5='tree -L 5'

alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'

# sudo apt -y install xclip
alias setclip='xclip -selection c'
alias clearclip='echo "" | xclip -selection c'
alias getclip='xclip -selection c -o'

alias top_cpu='ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 20'
alias top_mem='ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 20'
alias pid_info='ps -eo ppid,cmd,vsz,rss,%mem,%cpu -p'

alias git_search='git grep -n'

# export HISTSIZE=2000
# export PYSPARK_PYTHON=$(which ipython3)
# export SBT_OPTS="-Dsbt.override.build.repos=true"
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# go path
[ -d ~/.go/bin ] && export PATH=~/.go/bin:$PATH

alias quick_nmap='nmap -vv --max-retries=5 -sV -T4 -p-'
alias quick_rsync='rsync -arvP'
