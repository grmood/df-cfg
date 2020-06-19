# ============================================
# file:     utils.sh
# project:  exedots
# author:   Konstantin Vinogradov
# email:    exescript@gmail.com
#
# Bash utilites, helpers and shortcuts
#
# ============================================

export ARG_MAX=$(getconf ARG_MAX)
export CFG_ECHO_SEPLEN=32

export dnsfile="/etc/resolvconf/resolv.conf.d/head"
export devnull="/dev/null"

function reinit()       { include $exedir/exe.bashrc; }
function addpath()      { export PATH=$(set_ifd "$1:$PATH" "$PATH"); }

function squo()         { echo -ne "'$*'";  }
function dquo()         { echo -n "\"$@\""; }

function x_noout()   { eval "$* >$devnull";              }
function x_noerr()   { eval "$* 2>$devnull;";            }
function x_quiet()   { eval "$* >$devnull 2>$devnull;";  }

function x_loop()    { while true; do eval "$*" || break; done; echo "Evaluation error: $?"; }
function x_repeat()  { eval 'for idx in $(seq 1 '"$2"'); do $1; done;';  }

function x_if()      { eval "$1 && $2 && return 0"; } # || ($3 && return $?)";  }
function x_ifz()     { x_if "[ -z $(squo  $1) ]" "$2" "$3";  return "$?"; }
function x_ifnz()    { x_if "[ ! -z $(squo $1) ]" "$2" "$3"; return "$?"; }
function x_iff()     { x_if "[ -f $(squo $1)]" "$2" "$3";    return "$?"; }
function x_ifd()     { x_if "[ -d $(squo $1)]" "$2" "$3";    return "$?"; }
function x_ifnd()    { x_if "[ ! -d $(squo $1)]" "$2" "$3";   return "$?"; }

function echo_if()      { x_if "$1" "echo $2" "echo $3"; }
function echo_ifz()     { echo_if "[ -z $1 ]" "$2" "$3";    }
function echo_ifnz()    { echo_if "[ ! -z $1 ]" "$2" "$3";  }
function echo_iff()     { echo_if "[ -f $1 ]" "$2" "$3";    }
function echo_ifd()     { echo_if "[ -d $1 ]" "$2" "$3";    }

function set_if()       { echo_if  "$1" "$2" "$1";  }
function set_ifz()      { echo_ifz "$1" "$2" "$1";  }
function set_ifnz()     { echo_ifnz "$1" "$2";      }
function set_iff()      { echo_iff "$1" "$2" "$1";  }
function set_ifd()      { echo_ifd "$1" "$2" "$1";  }

function echo_rep()  { x_repeat "echo -ne $1" "$2"; }
function echo_ret()  { echo_rep "\r" "$1"; }
function echo_tab()  { echo_rep "\t" "$1"; }
function echo_spc()  { echo_rep " " "$1"; }
function echo_ln()   { echo_rep "\n" "$1"; }
function echo_sep()  { echo_rep "-" "$CFG_ECHO_SEPLEN"; }
function echo_del()  { echo_rep "\b" "$1"; }
function echo_adel() { echo_del "$ARG_MAX"; }

function drop_caches()  { free && sync && echo 3 > /proc/sys/vm/drop_caches && free; }
function findreplace()  { find . -name "$3" -type f | xargs perl -pi -e 's/$1/$2/g'; }

function own()          { sudo chown -R "$USER:$USER" "$1";     }
function cwd()          { echo $(cd "$(dirname "$0")" && pwd);  }
function up()           { cd $(echo_repeat '../' "$1");         }

function echo_iterate   { eval "$@"; [ "$?" -eq 0 ] && sleep 1 && echo_ret || (ret = 1 && echo "iter err" && return $ret); }
function watchcmd()     { x_loop "echo_iterate $@";          }

function wsize()    { watchcmd 'echo -ne $(sudo du -h -s -X '"$fexcludes $1"')';    }
function wmem()     { watchcmd 'echo -ne $(cat /proc/meminfo | grep -i memfree)';   }
function wuptime()  { watchcmd 'echo -ne "Uptime: $(uptime --pretty)"';             }

# shell helpers
function x_on() {
    local cdopt ret
    local path=$(set_ifz "$2" "$(pwd)")
    local ecmd="eval"
    local verbose="no"

    case "$3" in
    "-v" | "--verbose")
        echo "[ Verbose mode ]"
        verbose="yes"
        ecmd="eval"
        ;;
    "-q" | "--quiet")
        cdopt=">/dev/null 2>/dev/null"
        ecmd="x_quiet"
        ;;
    "-e" | "--no-out")
        cdopt=">/dev/null"
        ecmd="x_noout"
        ;;
    "-o" | "--no-err")
        cdopt="2>/dev/null"
        ecmd="x_noerr"
        ;;
    "*")
        cdopt=""
        ecmd="eval"
        ;;
    esac

    eval "cd '$path' $cdopt;"
    ret="$?"
    [ "$ret" -eq 0 ] || [ "$verbose" == "no" ] || echo "[ Error ] changing directory [ $ret ]"
    [ "$ret" -ne 0 ] && return $ret

    $ecmd "$1"
    ret="$?"
    [ "$ret" -eq 0 ] || [ "$verbose" == "no" ] || echo "[ Error ] command execution [ $ret ]"

    eval "cd '$OLDPWD' $cdopt;";
}

# measure cmd runtime
function tm() {
    local start="$(date +%s)"
    $@
    local exit_code=$?
    echo >&2 "took ~$(($(date +%s)-${start})) seconds. exited with ${exit_code}"
    return $exit_code
}

# String helpers
function fword()    { echo "${1%% *}"; }
function lword()    { echo "${1##* }"; }
# File helpers
function tailcut()      { sed -i -n -e :a -e "1,$(set_ifz "$2" "1")"'!{P;N;D;};N;ba' "$1"; }
function tailadd()      { echo -ne "$2" >> "$1"; }
function headadd()      { sed -i '1s/^/'"$2"' /' "$1"; }

function mkdate()       { date +"%Y_%m_%d_%I_%M_%S"; }
function mkdatedir()    { mkdir "$(mkdate)"; }

# Net shortcuts
function sniff()    { sudo lsof -Pan -i tcp -i udp; }

function wzr()      { curl "http://wttr.in;";    }
function wzr2day()  { curl "http://v2.wttr.in;"; }

# SSH helpers
function ssh_addr()     { LANG=C x_loop "ssh $1; sleep 5;";  }
function ssh_dmesg()    { ssh_addr "$1" "dmesg -w"; }
function ssh_forget()   { ssh-keygen -f "$HOME/.ssh/known_hosts" -R "$@"; }
function ssh_setup() {
    ssh $1 'mkdir -p -m 700 .ssh; touch .ssh/authorized_keys; chmod 600 .ssh/authorized_keys';
    cat ~/.ssh/id_rsa.pub | ssh $1 'cat - >> ~/.ssh/authorized_keys'
}

function ssh_tcpdump() {
    local filter=$(set_ifnz "$2" "-Y $2")
    ssh "$1" tcpdump -i any -U -s0 -w - 'not port 22' |  wireshark $filter -k -i -
}

function ssh_tcpdump_in() {
    local filter=$(set_ifnz "$2" "-Y $2")
    local host=${1##*@}
    local net=$(ipcalc -b $p3vm1 | grep Network)

    net=`echo $net | awk '{print $NF}'`
    ssh "$1" "tcpdump -i any -U -s0 -w - 'not port 22' and dst host $host and not src net $net" |  wireshark $filter -k -i -
}

# Git helpers
function gcmd()     { git -C "$(set_ifz $2 $(pwd))" $1; }

function gclone()   { gcmd "clone $1" "$2" && cd $(basename "$1" ".git"); }
function gbranch()  { gcmd "symbolic-ref --short HEAD" "$1";    }
function gstatus()  { gcmd "status --short" "$1";               }
function gpush()    { gcmd "push origin $(gbranch) -f" "$1";    }
function gadd()     { gcmd "add --all" "$1";    }
function grm()      { git   rm --cached "$@";   }

# creates an archive from given directory
function mktar() { tar cvf  "${1%%/}.tar"     "${1%%/}/"; }
function mktgz() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }
function mktbz() { tar cvjf "${1%%/}.tar.bz2" "${1%%/}/"; }
function extract () {
        if [ -f "$1" ] ; then
                case "$1" in
                        *.tar.bz2)  tar xjf $1            ;;
                        *.tar.gz)   tar xzf $1            ;;
                        *.bz2)      bunzip2 $1            ;;
                        *.rar)      unrar x $1            ;;
                        *.gz)       gunzip $1             ;;
                        *.tar)      tar xf $1             ;;
                        *.tbz2)     tar xjf $1            ;;
                        *.tgz)      tar xzf $1            ;;
                        *.zip)      unzip $1              ;;
                        *.Z)        uncompress $1         ;;
                        *.rpm)      rpm2cpio "$1" | cpio -idmvD $(basename "$1" ".rpm") ;;
                        *)          echo "'$1' cannot be extracted via extract()" ;;
                esac
        else
                echo "'$1' is not a valid file"
        fi
}

# Searches for text in all files in the current folder
function ftext()
{
    argv=("$@")
    argc=${#argv[@]}

    eval "(( $argc > 1 ))"; cond="$?"
    dir="$(echo_if "[ $cond == 0 ]" $(dquo "${argv[0]}") '.')"
    args="$(echo_if "[ $cond == 0 ]" "${*:2}" "$1")"

    eval "grep -iIHrn --color=always ${args[*]} $dir | less -r"
}

# Base64
function en64 () { echo "$1" | base64 -d; echo; }
function de64 () { echo "$1" | base64;    echo; }

# Find array index
function fidx() {
    local val="$1"; shift;
    local arr=("$@"); 
    local cnt=${#{arr[@]}};
    local N=$(( $cnt - 1 ))

    for i in $(seq 0 "$N"); do [ "${arr[$i]}" == "$val" ] && echo "$i" && break; done
}

# list users (based on /etc/passwd)
function lsusers() {
    local fmt="%-20s %-7s %-7s %-28s %s\n"
	printf "$fmt" "USERNAME" "UID" "GID" "HOME" "SHELL"

	while IFS=':' read -r user pass uid gid uext home shell
    do
		if [ "$1" == "--nosys" ]; then
            if [[ "$shell" == *"/nologin" ]] || [[ "$shell" == *"/false" ]] ||\
                [[ "$home" == *"/bin" ]] || [[ "$home" == *"/sbin" ]]; then
                continue
            fi
        fi
		printf "$fmt" "$user" "$uid" "$gid" "$home" "$shell"
	done < /etc/passwd
}

function service_up() {
    x_quiet "sudo service $1 start" &&
    x_quiet "sudo service $1d start";
    x_quiet "sudo systemctl start $1.service" &&
    x_quiet "sudo systemctl start $1" &&
    x_quiet "sudo systemctl start $1";
}

function service_down() {
    x_quiet "sudo systemctl stop $1.service";
    x_quiet "sudo systemctl stop $1";
    x_quiet "sudo service $1 stop ";
}

function service_disable() {
    service_down "$1";
    x_quiet "sudo systemctl disable $1.service" &&
    x_quiet "sudo systemctl disable $1"
}

function scsi_disable() {
    servoce_disable iscsi
    servoce_disable iscsid
    service_disable multipath
    service_disable multipathd

    x_quiet 'sudo modprobe -r -f iscsi_tcp'
    x_quiet 'sudo modprobe -r -f libiscsi_tcp'
    x_quiet 'sudo modprobe -r -f ib_iser'
    x_quiet 'sudo modprobe -r -f libiscsi'
    x_quiet 'sudo modprobe -r -f scsi_transport_iscsi'
    x_quiet 'sudo modprobe -r -f scsi_dh_emc'
    x_quiet 'sudo modprobe -r -f scsi_dh_rdac'
    x_quiet 'sudo modprobe -r -f scsi_dh_alua'
}

# Kernel helpers
export kgit="https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git"
export kcdn="https://cdn.kernel.org/pub/linux/kernel"

function kver() { echo $(ssh "$1" "cd /lib/modules; ls -1dvr [0-9]* | head -1" 2>/dev/null); }
function kcfg() {
    local ver=$(set_ifz "$2" "$(kver $1)") 
    scp $1:/boot/config-$ver ./.config
}

function kclone() {
    local branch=$(set_ifz "$1" "master")
    local dst=$(set_ifz "$2" "./linux-$branch")

    git clone "$kgit" -b "$branch" "$dst";
}

function ktarball() {
    local version="$1"
    local dir=$(set_ifz "$2" "$(pwd)")

    local major="${version%%.*}"
    local uri="$kcdn/v$major.x/linux-$version.tar.xz"

    wget --show-progress --directory-prefix="$dir" "$kcdn/v$major.x/linux-$version.tar.xz"
}

function makejp()   { make "$@" "-j$(nproc)"; }
function histgrep   { history | grep -i $1 ;  }
function findpkg()  { dpkg -S $(which "$1");  }

function wifikeys() { sudo grep -r '^psk=' /etc/NetworkManager/system-connections/; } 
alias wifikey="wifikeys | grep"
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
alias noerr="x_noerr"
alias quiet="x_quiet"

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
