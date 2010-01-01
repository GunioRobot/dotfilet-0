# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# load individual init files
if [ -d ~/.bashrc.d ]; then
    for file in $(/bin/ls ~/.bashrc.d/S*); do
        echo "loading $file"
        . "$file"
    done
fi

# load other stuff that hasn't yet been ported to individual init files

# ** only for HRWorX development, and State of MN specifically
export CVS_RSH=ssh
export CVSROOT=:ext:resweb:/home/cvs/cvsroot

if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# can't be in a sub-init, because that's in a subshell?
if [ "$PS1" ]; then
    PS1='\u@\h:\w\$ '
fi

export GEMDIR=`gem env gemdir`

gemdoc() {
  open $GEMDIR/doc/`$(which ls) $GEMDIR/doc | grep $1 | sort | tail -1`/rdoc/index.html
}

_gemdocomplete() {
  COMPREPLY=($(compgen -W '$(`which ls` $GEMDIR/doc)' -- ${COMP_WORDS[COMP_CWORD]}))
  return 0
}

complete -o default -o nospace -F _gemdocomplete gemdoc

_mategem() {
    local curw
    COMPREPLY=()
    curw=${COMP_WORDS[COMP_CWORD]}
    local gems="$(gem environment gemdir)/gems"
    COMPREPLY=($(compgen -W '$(ls $gems)' -- $curw));
    return 0
}
complete -F _mategem -o dirnames mategem