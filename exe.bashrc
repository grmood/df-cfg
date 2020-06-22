_cdir() { echo "$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)"; }

export exedir="$(_cdir)";
export execfg="$exedir/cfg"
export exesrc="$exedir/src"

# uncomment line to enable
# log 'dbg' message type printing
# export EXE_DBG=y

function var_get()   { eval "echo \$$1"; }
function var_set()   { eval "export $1=$2"; }

function var_sety()  { var_set "$1" "y"; }
function var_setn()  { var_set "$1" "n"; }
function var_unset() { var_set "$1" ""; }

function file2tag() {
    local fname=$(basename $1)
    echo "_$(echo $fname | tr a-z A-Z | tr [:punct:] '_' | tr -d [:cntrl:])_";
}

source "$exesrc/debug.sh"
source "$exesrc/shell.sh"

function module_include() {
    local modname="$1"
    local modfile="$exesrc/$1.sh"
    local modfunc="$1_include"

    export _exe_mod_name="$modname"
    export _exe_mod_path="$exesrc/$1"

    [ -z "$1" ] && return 1 || shift;
    [ -f "$modfile" ] || return 1;

    include "$modfile" && eval "$modfunc $@" || return 1;

    var_sety "$(file2tag $modname)"
}

function module_exclude() {
    local modname="$1"
    local modfile="$exesrc/$1.sh"
    local modfunc="$1_exclude"

    export _exe_mod_name="$modname"
    export _exe_mod_path="$exesrc/$1"

    [ -z "$1" ] && return 1 || shift;
    eval "x_quiet $modfunc $@" || return 1;

    var_unset "$(file2tag $modfile)"
}

function module_reinclude() {
    local modname="$1"

    module_exclude "$modname"
    mofule_include "$modname"
}

function exclude_all() {
    module_exclude "utils"
    module_exclude "work"

    exclude "$exesrc/.private.sh"
    exclude "$exedir/rc.d"
}

function include_all() {
    # include main modules
    module_include "utils"
    module_include "work"

    # include user modules
    include "$exedir/rc.d"
    include "$exesrc/.private.sh"
}

exclude_all;
include_all;

dbg "Workspace user directory: '$work'"
[ -d $work ] || {
    dbg "Workspace directory doesn't exist"
    dbg "Create workspace directory : '$work'"

    xquiet "mkdir $work" ||
        fatal "1" "make workspace failed: '$work'";
}

wdirs=( build logs tmp src bin )
for d in "${wdirs[@]}"; do
    [ ! -d $work/$d ] && {
        logi "Make workspace subdirectory: '$d' ";
        ( ! mkdir $work/$d ) && logf || logo;
    } || dbg "exedots: workspace subdirectory '$work/$d' already exists";
done



