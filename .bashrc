# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color)
		PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\[\033[1;31m\]\$ \[\033[00m\]'
		;;
	*)
		PS1='\[\033[1;32m\]\u@\h\[\033[00m\]:\[\033[1;33m\]\w\[\033[1;36m\]$(git_info)\[\033[00m\]\n\[\033[1;31m\]\$ \[\033[00m\]'
		;;
esac

# If this is an xterm set the title to user@host:dir
case "$TERM" in
	xterm*|rxvt*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
		;;
	*)
		;;
esac


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
   . ~/.bash_aliases
fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
	eval "`dircolors -b`"
	alias ls='_ls'
fi

if [ "$TERM" == "xterm" ]; then
    export TERM="xterm-256color"
fi


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).

# if [ -f /etc/bash_completion ]; then
# 	. /etc/bash_completion
# fi


# Personal Aliases

if [ -e $HOME/.alias ]; then
	. $HOME/.alias
fi


# Local Functions and Commands

function git_info {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return;
    last_commit=$(git log --pretty=format:%at -1 2> /dev/null) || return;
    now=`date +%s`;
    sec=$((now-last_commit));
    min=$((sec/60)); hr=$((min/60)); day=$((hr/24)); yr=$((day/365));

    if [ $min -lt 60 ]; then
        info="${min}m"
    elif [ $hr -lt 24 ]; then
        info="${hr}h$((min%60))m"
    elif [ $day -lt 365 ]; then
        info="${day}d$((hr%24))h"
    else
        info="${yr}y$((day%365))d"
    fi

    echo "(${ref#refs/heads/} $info)";
}


function old() {
    day=$1; shift
    find . -maxdepth 1 -mtime +${day} $@
}

function _ls() {
    LANG=zh_TW.BIG5
    /bin/ls -C --color=always $@ #| /usr/bin/iconv -f big5 -t utf8
    LANG=zh_TW.UTF-8
}


export PATH="$PATH:$HOME/bin:/usr/local/go/bin"
