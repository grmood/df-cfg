export devnull="/dev/null"

function var_get()   { eval "echo \$$1"; }
function var_set()   { eval "export $1=$2"; }

function var_sety()  { var_set "$1" "y"; }
function var_setn()  { var_set "$1" "n"; }
function var_unset() { var_set "$1" ""; }

function xdbg() { eval "set -x; $1; set +x;"; }

function xnoout() { eval "$* >$devnull";              }
function xnoerr() { eval "$* 2>$devnull";            }
function xquiet() { eval "$* >$devnull 2>$devnull";  }

function xloop() { while true; do eval "$*" || break; done; echo "Evaluation error: $?"; }
function xrep()  { eval 'for idx in $(seq 1 '"$2"'); do $1; done;';  }

function xf()   {
    local cmdok="$2"
    local cmdfail="$3"
    local cmd="$1 && ( $cmdok )";

    [ ! -z "$cmdfail" ] &&
        cmd="$cmd || ( $cmdfail )";

    # echo "xf: cmd: $cmd"
    cmd=$(echo $cmd | tr -d [:cntrl:])
    eval "$cmd"
    # eval "$1 && $cmdok || ( [ ! -z $cmdfail ] && $cmdfail; )";
}

function xfz()  { xf "[ -z $1 ]" "$2" "$3"; }
function xfnz() { xf "[ ! -z $1 ]" "$2" "$3"; }
function xff()  { xf "[ -f $1 ]" "$2" "$3"; }
function xfd()  { xf "[ -d $1 ]" "$2" "$3"; }
function xfnd() { xf "[ ! -d $1 ]" "$2" "$3"; }

function xfok()   { eval "( exit $?;) && $@"; }
function xferr()  { eval "( exit $?;) || $@"; }

function ef()    { xf "$1" "echo $2" "echo $3"; }

function efz()   { ef "[ -z $1 ]" "$2" "$3"; }
function efnz()  { ef "[ ! -z $1 ]" "$2" "$3"; }
function eff()   { ef "[ -f $1 ]" "$2" "$3"; }
function efd()   { ef "[ -d $1 ]" "$2" "$3"; }

function efok()  { xfok  "$1"; }
function eferr() { xferr "$1"; }

function logf()   { xf "$1" "log info $2" "log info $3";  }

function logfz()  { logf "[ -z $1 ]" "$2" "$3";   }
function logfnz() { logf "[ ! -z $1 ]" "$2" "$3"; }
function logff()  { logf "[ -f $1 ]" "$2" "$3";   }
function logfd()  { logf "[ -d $1 ]" "$2" "$3";   }

function logfok()  { xfok  "log $@"; }
function logferr() { xferr "log $@"; }

function setf()   { ef   "$1" "$2" "$1"; }
function setfz()  { efz  "$1" "$2" "$1"; }
function setfnz() { efnz "$1" "$2";      }
function setff()  { eff  "$1" "$2" "$1"; }
function setfd()  { efd  "$1" "$2" "$1"; }

# execute command after dir changing and return
function xcd() {
    local cdopt ret

    local ecmd="eval"
    local verbose="no"

    case "$1" in
    "-v" | "--verbose")
        echo "[ Verbose mode ]"
        verbose="yes"
        ecmd="eval"
        shift;
        ;;
    "-q" | "--quiet")
        cdopt=">/dev/null 2>/dev/null"
        ecmd="xquiet"
        shift;
        ;;
    "-e" | "--no-out")
        cdopt=">/dev/null"
        ecmd="xnoout"
        shift;
        ;;
    "-o" | "--no-err")
        cdopt="2>/dev/null"
        ecmd="xnoerr"
        shift;
        ;;
    "*")
        cdopt=""
        ecmd="eval"
        ;;
    esac

    local path="$1"; shift;
    local oldpath=$(pwd);

   	local cdon="cd $path $cdopt"
   	local cdback="cd $oldpath $cdopt"

    $ecmd "$cdon"; ret="$?"

    [ "$ret" -eq 0 ] || {
    	[ "$verbose" == "yes" ] && loge "xcd: fail to change dir [ $ret, '$path' ]"
    	return $ret
    }

    $ecmd "$cdon && $@"; ret="$?";
    [ "$ret" -eq 0 ] || {
    	[ "$verbose" == "yes" ] && loge "xcd: fail to execute [ $ret, '$@' ]"
    }

    $ecmd "$cdback";
}

function included() {
    [ -z "$1" ] && { echo "empty filename: '$1'"; return 1; }
    
    local tag=$(file2tag "$1");
    local val=$(var_get "$tag");

    [ "$val" == "y" ] && return 0;
    [ "$val" == "n" ] && { logw "partialy included: ( $1 )"; return 0; }

    return 1;
}

function _include() {
	dbg "include: file [ '$1' ]"
    local tag=$(file2tag $1)

    [ ! -f "$1" ] && { loge "include: file doesn't exist: '$1'"; return; }
    included "$1" && { dbg "include: file already included: '$1'"; return; }

    var_setn "$tag" && source "$1" && var_sety "$tag" || {
        loge "include: file contains errors [ '$1' ]";
        return;
    }
}

function include() {
    [ -z "$1" ] && { loge "include error: empty filename"; return; }

    [ -d "$1" ] && {
        for f in $1/*; do
        	_include "$f";
        done;
 
        return;
    }

    [ -f "$1" ] && { _include "$1"; return; }

    loge "include: unknown error ( '$1' )";
}

function include_safe() {
    [ -d "$1" ] && {
        for f in $1/*; do
            var_unset "$(file2tag $f)";
        done
    }

	var_unset "$(file2tag $1)";

    include "$1"
}

function _exclude() {
	dbg "exclude: file [ '$1' ]"
    [ ! -f "$1" ] || [ ! -d "$1" ] && {
        dbg "exclude: no such file or dir: '$1'"
    }

    local tag=$(file2tag $1);
    var_unset "$tag";
}

function exclude() {
    [ -z "$1" ] && { loge "exclude error: empty filename"; return; }
    [ -d "$1" ] && {
        dbg "exclude: directory [ '$1' ]"
        for f in $1/*; do _exclude "$f"; done;
 
        return;
    }
    [ -f "$1" ] && {
        _exclude "$1";

        return;
    }
    loge "exclude: unknown error ( '$1' )";
}
