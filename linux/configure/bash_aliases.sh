# path: ~/apps/bash_aliases
# $ ln -sr ~/apps/bash_aliases ~/.bash_aliases
# $ mkdir -p ~/apps/x/bin

#### 1.
# export HISTTIMEFORMAT="%Y-%m-%dT%H:%M:%S%z "
# %Y-%m-%dT%H:%M:%S%:z doesn't work as expected
# export HISTTIMEFORMAT="%Y%m%d-%H%M-%s "
export HISTTIMEFORMAT="%Y-%m-%d %H:%M %s  "
export PROMPT_DIRTRIM=2

export PATH=~/apps/bin:$PATH # PATH=~/.local/bin:$PATH

# mkdir -p apps/exports
# tar -xf downloads/go1.23.4.linux-amd64.tar.gz -C apps/
# ln -rs apps/go apps/exports

for d in $(ls -d ~/apps/exports/*/ 2> /dev/null); do
    d=${d%/}
    b=$(basename $d)
    #[ "${b:0:1}" == "_" ] && continue
    [ -d $d/bin ] && d=$d/bin
    [ -r $d ] || continue
    export PATH=$d:$PATH
done

#### 2.
alias tree2='tree -L 2'
alias tree3='tree -L 3'

alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'

alias quick_rsync='rsync -arvP'
alias quick_nmap='nmap -vv --max-retries=5 -sV -T4 -p-'

#### 3.
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
