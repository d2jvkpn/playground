export HISTTIMEFORMAT="%Y-%m-%d %H:%M %s  "
export PROMPT_DIRTRIM=2

export PATH=~/apps/bin:$PATH # PATH=~/.local/bin:$PATH

# mkdir -p ~/apps/exports
# tar -xf downloads/go1.23.4.linux-amd64.tar.gz -C apps/
# ln -rs apps/go apps/exports/

for d in $(ls -d ~/apps/exports/*/ 2> /dev/null); do
    d=${d%/}
    b=$(basename $d)
    #[ "${b:0:1}" == "_" ] && continue
    [ -d $d/bin ] && d=$d/bin
    [ -r $d ] || continue
    export PATH=$d:$PATH
done
