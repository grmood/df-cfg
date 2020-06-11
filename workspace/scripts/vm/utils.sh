. $work/progress-bar.sh
. $work/iscsi.utils.sh

export exit_from_ssh='[enter]~.'

# shell helpers
function exec_on() {
    local cmd="$1"
    local path="$2"
    if [ -z "$path" ]; then
        path=$(pwd 2>/dev/null)
    fi
    cd $path; $cmd; cd -;
}

function findreplace() { find . -name "$3" -type f | xargs perl -pi -e 's/$1/$2/g'; }

function squo() { printf "'%s'\n\" \"\$*"; }
function dquo() { printf "\"%s\"\n" "$*"; }
function cwd()  { echo $(cd "$(dirname "$0")" && pwd); }
function up()   { for i in $(seq 1 ${1:-"1"}); do cd ../; done; }

function mkdate()    { date +"%Y_%m_%d_%I_%M_%S"; }
function mkdatedir() { mkdir "$(mkdate)"; }
function reinit()    { . ~/.bash_profile; }
function addpath()   { export PATH="$1:$PATH"; }
function loop()      { while true; do bash -c "$@"; done; }
function ssh_addr()  { loop "LANG=C ssh $1; sleep 5;"; }

# Net shortcuts
function vpn_up()   { exec_on "sudo ./connect.sh" "$vpn"; }
function vpn_down() { sudo pkill openvpn; }
function sniff()    { sudo lsof -Pan -i tcp -i udp; }
function wzr()      { curl http://wttr.in;    }
function wzr2day()  { curl http://v2.wttr.in; }
function telegram() { $HOME/Telegram/Telegram; }

function fword() { echo "${1%% *}"; }
function lword() { echo "${1##* }"; }
function tailcut() {
    local file="$1"
    local num="$2"

    if [ -z $num ]; then
        num="1"
    fi

    sed -i -n -e :a -e "1,$num"'!{P;N;D;};N;ba' $file
}

function ssh_tcpdump_in() {
    local addr="$1"
    local filter="$2"

    local host=${addr##*@}
    local net=`ipcalc -b $p3vm1 | grep Network`

    if [ ! -z $filter ]; then
        local filter_opt="-Y $filter"
    fi

    net=`echo $net | awk '{print $NF}'`
    ssh "$addr" "tcpdump -i any -U -s0 -w - 'not port 22' and dst host $host and not src net $net" |  wireshark $filter_opt -k -i -
}

function ssh_tcpdump() {
    local addr="$1"
    local filter="$2"

    if [ ! -z $filter ]; then
        local filter_opt="-Y $filter"
    fi

    ssh "$addr" tcpdump -i any -U -s0 -w - 'not port 22' |  wireshark $filter_opt -k -i -
}

# Git helpers
function gclone()  { git clone "$1"; cd $(basename "$1" .git); }
function gbranch() { git symbolic-ref --short HEAD; }
function gstatus() { git status --short -uno; }
function gpush()   { git push origin $(gbranch) -f; }
function gadd() {
    readarray -t files < <( gstatus )
    for str in "${files[@]}"
    do
        file=$(lword "$str")
        git add --verbose "$file"
    done
}
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

# Base64
function en64 () { echo "$1" | base64 -d ; echo; }
function de64 () { echo "$1" | base64 ; echo; }

function idx() {
    local elem="$1"
    shift

    local arr=("$@")
    local count=${#arr[@]}

    for (( i=0; i<${count}; i++ ))
    do
        if [ "${arr[$i]}" == "$elem" ]; then
            echo $i
            break
        fi
    done
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

# measure cmd runtime
function tm() {
	local start="$(date +%s)"
	$@
	local exit_code=$?
	echo >&2 "took ~$(($(date +%s)-${start})) seconds. exited with ${exit_code}"
	return $exit_code
}

# Kernel helpers
export kgit="https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git"
export kcdn="https://cdn.kernel.org/pub/linux/kernel"

function kver() { echo $(ssh "$1" "cd /lib/modules; ls -1dvr [0-9]* | head -1" 2>/dev/null); }
function kcfg() {
    local uri="$1"
    local ver="$2"

    if [ -z "$ver" ]; then
        ver=$(kver "$uri")
    fi

    scp $uri:/boot/config-$ver ./.config
}

function kclone() {
    branch="$1"
    if [ -z "$branch" ]; then
        branch="master"
    fi
    dst="$2"
    if [ -z "$dst" ]; then
        dst="./linux-$branch"
    fi

    git clone "$kgit" -b "$branch" "$dst";
}

function ktarball() {
    local version="$1"
    local dir="$2"

    if [ -z "$dir" ]; then
        dir=`pwd`
    fi

    local major="${version%%.*}"
    local uri="$kcdn/v$major.x/linux-$version.tar.xz"

    wget --show-progress --directory-prefix="$dir" "$kcdn/v$major.x/linux-$version.tar.xz"
}

function findpkg()  { dpkg -S $(which "$1"); }
function wifikeys() { sudo grep -r '^psk=' /etc/NetworkManager/system-connections/; } 
alias wifikey="wifikeys | grep"
alias youtube-mp3="youtube-dl --extract-audio --audio-format mp3"

alias sai="sudo apt install"
alias sai="sudo apt-get install"
alias sau="sudo apt update"
alias sau="sudo apt-get update"
alias acs="apt-cache search"
alias cppwd='pwd | xclip'
alias cdclip='cd $(xclip -o)'
alias mnt='mount | column -t'
alias se="sudo echo"
alias g="git"
alias c="clear"

addpath "$HOME/.emacs.d/bin"
addpath "$HOME/.cask/bin"
