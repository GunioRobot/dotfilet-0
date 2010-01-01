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

# export JAVA_HOME=/usr/local/java5
export JAVA_HOME=/usr/local/java6

export MAVEN_HOME=/usr/local/maven
export POSTGRESQL_HOME=$MACPORTS_HOME/lib/postgresql83
export SUBVERSION_HOME=/opt/subversion

export MAVEN_OPTS="-Dfile.encoding=UTF-8 -Xms128m -Xmx256m"

export PATH=$HOME/bin:$SUBVERSION_HOME/bin:$MACPORTS_HOME/bin:$MACPORTS_HOME/sbin:$MAVEN_HOME/bin:$JAVA_HOME/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/usr/X11R6/bin:$POSTGRESQL_HOME/bin
export MANPATH=$MACPORTS_HOME/share/man:/usr/local/share/man:/usr/share/man:/usr/local/man
export INFOPATH=$MACPORTS_HOME/share/info:/usr/share/info
# export DYLD_LIBRARY_PATH=$MACPORTS_HOME/lib/oracle/:$MACPORTS_HOME/lib
# export LD_LIBRARY_PATH=$MACPORTS_HOME/lib
export RUBYLIB=$HOME/lib/ruby

export RSYNC_RSH=ssh

# ** only for HRWorX development, and State of MN specifically
export CVS_RSH=ssh
export CVSROOT=:ext:resweb:/home/cvs/cvsroot

# RVM support
if [ -f ~/.rvm/bin/rvm ]; then
    . ~/.rvm/bin/rvm
fi
if [ -f ~/.rvm/current ]; then
    . ~/.rvm/current
fi
export PATH=$HOME/.rvm/bin:$PATH

if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if [ -f $MACPORTS_HOME/etc/bash_completion ]; then
    . $MACPORTS_HOME/etc/bash_completion
fi
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
if [ -f $HOME/.bash_completion ]; then
    . $HOME/.bash_completion
fi
complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh

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