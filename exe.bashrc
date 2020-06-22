_cdir() { echo "$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)"; }

export _exe_path="$(_cdir)";
export _exe_cfg_path="$_exe_path/cfg"
export _exe_src_path="$_exe_path/src"
export _exe_rc_name="exe.bashrc"
export _exe_user_rc_path="$_exe_src_path/rc.d"

core_mods=( "utils" "work" )
user_mods=(  )

# uncomment line to enable
# log 'dbg' message type printing
# export EXE_DBG=y

source "$_exe_src_path/debug.sh"
source "$_exe_src_path/shell.sh"

function file2tag() {
    local fname=$(basename $1)
    echo "_$(echo $fname | tr a-z A-Z | tr [:punct:] '_' | tr -d [:cntrl:])_";
}

function module_include() {
    local modname="$1"
    local modfile="$_exe_src_path/$1.sh"
    local modfunc="$1_include"

    export _exe_mod_name="$modname"
    export _exe_mod_path="$_exe_src_path/$1"

    shift;

    [ -z "$modname" ] && return 1;
    [ -f "$modfile" ] || return 1;

    include_safe "$modfile";

    eval "$modfunc $@" || return 1;

    var_sety "$(file2tag $modname)";
}

function module_include_safe {
    var_unset "$(file2tag $1)"

    module_include "$1" "$@"
}

function module_exclude() {
    local modname="$1"
    local modfile="$_exe_src_path/$1.sh"
    local modfunc="$1_exclude"

    export _exe_mod_name="$modname"
    export _exe_mod_path="$_exe_src_path/$1"

    [ -z "$modname" ] && return 1; shift;

    eval "x_quiet $modfunc $@";
    exclude "$modfile";

    var_unset "$(file2tag $modname)"
}

function module_reinclude() {
    local modname="$1"

    module_exclude "$modname"
    module_include "$modname"
}

function mods_deinit() {
    module_exclude "utils"
    module_exclude "work"

    exclude "$_exe_src_path/.private.sh"
    exclude "$_exe_user_rc_path"
}

function core_init() {
    for m in "${core_mods[@]}"; do
        var_unset "$(file2tag ${m})";

        module_include "$m";
    done
}

function core_deinit() {
    for m in "${core_mods[@]}"; do
        var_unset "$(file2tag ${m})";

        module_exclude "$m";
    done
}

function user_init() {
    # include user modules
    include_safe "${_exe_src_path}/rc.d"
    include_safe "${_exe_src_path}/.private.sh"

    for m in "${user_mods[@]}"; do
        var_unset "$(file2tag ${m})";

        module_include "${m}";
    done;
}

function user_deinit() {
    for m in "${user_mods[@]}"; do
        var_unset "$(file2tag ${m})";

        module_exclude "$m";
    done;

    exclude "$_exe_src_path/.private.sh"
    exclude "$_exe_user_rc_path"
}

function exe_init() {
    core_init;
    user_init;
}

function exe_deinit() {
    user_deinit;
    core_deinit;
}

# exe_deinit
exe_init


