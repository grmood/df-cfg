alias youtube-mp3="youtube-dl --extract-audio --audio-format mp3"

alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

alias d="dmesg"
alias dw="dmesg -w"
alias mnt='mount | column -t'
alias mo='mount'
alias um='unmount'

alias sai="sudo apt install"
alias sai="sudo apt-get install"
alias sau="sudo apt update"
alias sau="sudo apt-get update"
alias acs="apt-cache search"

alias du="du -h"
alias g="git"
alias c="clear"

alias sfind="sudo find"
alias svim="sudo vim"
alias snano="sudo nano"
alias scat="sudo cat"
alias sssu="sudo su"

alias cppwd='pwd | xclip'
alias cdclip='cd $(xclip -o)'

alias RM="sudo rm -rf"

alias noout="x_nout"
alias noerr="xnoerr"
alias quiet="xquiet"

alias h='history | tail -10'
alias hi='history'

alias echon="echo -n"
alias echoe="echo -e"
alias echone="echo -ne"
alias echoen="echo -en"

alias se="sudo echo"
alias secho="sudo echo"
alias sechon="sudo echo -n"
alias sechoe="sudo echo -e"
alias sechone="sudo echo -ne"
alias sechoen="sudo echo -en"

alias wifikey="wifikeys | grep"