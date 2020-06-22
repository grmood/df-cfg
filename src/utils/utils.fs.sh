# Filesystem helpers

function findreplace() {
	local fexpr="$3";
	find . -name "$fexpr" -type f | xargs perl -pi -e 's/$1/$2/g';
}

function mkdate()    { date +"%Y_%m_%d_%I_%M_%S"; }
function mkdatedir() { mkdir "$(mkdate)"; }

function mkdirs() {
    local dirs=$@;
    local flags="";

    [ "$1" == "-f" ] && { 
        dbg "o-> force directories creation"

        dirs="${dirs[@]:1}";
        flags="-p";
    }

    for d in $dirs; do
        [ -d "$d" ] || mkdir "$flags" "$";
    done
}

# creates an archive from given directory
function mktar() { tar cvf  "${1%%/}.tar"     "${1%%/}/"; }
function mktgz() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }
function mktbz() { tar cvjf "${1%%/}.tar.bz2" "${1%%/}/"; }
function extract () {
        [ ! -f "$1" ] && {
            loge "extract: invalid filename: '$1'";
            return 1;
        }

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
            *)          loge "'$1' cannot be extracted via extract()" ;;
                esac
}

# File helpers
function tailcut() {
	sed -i -n -e :a -e "1,$(setfz "$2" "1")"'!{P;N;D;};N;ba' "$1";
}

function tailadd() { echo -ne "$2" >> "$1"; }
function headadd() { sed -i '1s/^/'"$2"' /' "$1"; }

# Searches for text in all files in the current folder
function ftext()
{
    argv=("$@")
    argc=${#argv[@]}

    eval "(( $argc > 1 ))"; cond="$?"
    dir="$(logf "[ $cond == 0 ]" $(dquo "${argv[0]}") '.')"
    args="$(logf "[ $cond == 0 ]" "${*:2}" "$1")"

    eval "grep -iIHrn --color=always ${args[*]} $dir | less -r"
}
