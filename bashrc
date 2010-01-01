# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

export EDITOR=vi
export LC_CTYPE=en_US.UTF-8

# export JAVA_HOME=/usr/local/java5
export JAVA_HOME=/usr/local/java6

export MACPORTS_HOME=/opt/local
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

# aliases for GNU utilities, which DarwinPorts prefixes with "g"
alias du='gdu'
alias find='gfind'
alias ls='gls'
alias md5sum='gmd5sum'

export LESS="--hilite-search --tabs=4"

# EOL corrections -- Mac (<CR>,\r); Unix (<LF>,\n); Win (<CRLF>,\r\n)
alias mac2unix="perl -pi -e 's/\r/\n/g'"
alias unix2mac="perl -pi -e 's/\n/\r/g'"
alias win2unix="perl -pi -e 's/\r\n/\n/g'"
alias unix2win="perl -pi -e 's/\n/\r\n/g'"
alias win2mac="perl -pi -e 's/\r\n/\r/g'"
alias mac2win="perl -pi -e 's/\r/\r\n/g'"

# other aliases
# alias gitprep='find . \( -type d -empty \) -and \( -not -regex ./\.git.* \) -exec touch {}/.gitignore \;'
alias grep="grep --color=auto"
alias mr="svn update; mvn release:prepare -Dusername=ccotting"
alias netlisten="netstat -naf inet | grep LISTEN"
alias psgrep="ps axwww | grep"
# alias ss="/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine"
alias top="top -F -R -o cpu -s 2"

# if running interactively, then:
if [ "$PS1" ]; then

    # fix the backspace and forward delete keys?
    stty erase   # there's a ^H at the end of this line
    
    # enable color support of ls
    export LS_COLORS='no=00:fi=00:di=00;33:ln=00;36:pi=00;35:so=00;35:bd=00;37:cd=00;37:or=01;33;41:'
    alias ls='gls --color=auto'

    # set a fancy prompt
    export PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME}\007"'
    PS1='\u@\h:\w\$ '

    # set up environment for X11
    export DISPLAY=":0.0"
    # if [ ! $SSH_TTY ] && [ ! $DISPLAY ]; then
    #     DISPLAY_FILE=$HOME/tmp/X11-display-`hostname -s`
    #     DISPLAY=`cat $DISPLAY_FILE 2>/dev/null`
    #     if xwininfo -display "$DISPLAY" -root >/dev/null 2>&1; then
    #         export DISPLAY
    #     else
    #         echo X11 display $DISPLAY not active
    #         unset DISPLAY
    #         rm -f "$DISPLAY_FILE"
    #     fi
    # fi
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