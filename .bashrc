# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export work="/home/exe/workspace"
#source "$BASH_IT"/bash_it.sh

export scripts="$work/scripts"
export vpn="$scripts/vpn/k.vinogradov-vpn01"
export src="$work/src"
export docs="$work/docs"

export fenv="$work/env.sh"
export futils="$work/utils.sh"

source "$fenv"
source "$futils"

# [[ -s "$work/git-mode.sh" ]] && source "$work/git-mode.sh"

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

#if [ -f $work/bash_prompt.sh ]; then
#    . $work/bash_prompt.sh
#fi
#aif [ -f "$work/LS_COLORS" ]; then
  # Get those nice ls colors
#  eval $( dircolors -b "$work/LS_COLORS" )
#fi

# export PS1='[$(date +%k:%M:%S)]\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\> '
#export PROMPT_COMMAND='echo -n "[$(date +%k:%M:%S)] "; __git_ps1 "\u@\h:\w" "\\\$ "'


# Bash prompt customizations:
#BASH_FUNK_NO_PROMPT=1           # if set to any value bash-funk will not install it's Bash prompt function.
#BASH_FUNK_PROMPT_PREFIX=        # text that shall be shown at the beginning of the Bash prompt, e.g. a stage identifier (DEV/TEST/PROD)
#export BASH_FUNK_PROMPT_DATE="\d \t"   # prompt escape sequence for the date section, default is "\t", which displays current time. See http://tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html
#BASH_FUNK_PROMPT_NO_JOBS=1      # if set to any value the Bash prompt will not display the number of shell jobs.
#BASH_FUNK_PROMPT_NO_SCREENS=1   # if set to any value the Bash prompt will not display the number of detached screens
#BASH_FUNK_PROMPT_NO_TTY=1       # if set to any value the Bash prompt will not display the current tty.
#BASH_FUNK_PROMPT_NO_KUBECTL=1   # if set to any value the Bash prompt will not display kubectl's current context
#BASH_FUNK_PROMPT_NO_GIT=1       # if set to any value the Bash prompt will not display GIT branch and modification information.
#BASH_FUNK_PROMPT_NO_SVN=1       # if set to any value the Bash prompt will not display SVN branch and modification information.
#BASH_FUNK_PROMPT_DIRENV_TRUSTED_DIRS=() # Bash array of directory paths where found .bash_funk_auto_rc files automatically executed.

source "$work/bash-prompt.sh"
