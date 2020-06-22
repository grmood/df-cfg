# ============================================
# file:     utils.sh
# project:  exedots
# author:   Konstantin Vinogradov
# email:    exescript@gmail.com
#
# ============================================
# Module: utils
#
# Bash utilites, helpers and shortcuts
#
# ============================================

export ARG_MAX=$(getconf ARG_MAX)
export CFG_ECHO_SEPLEN=32

export _utils_src_dir_="$_exe_src_path/utils"

utils=(
    str log arr sys fs git
    shell kernel os net
)

dbg "utils: ${utils[*]}"

function utils_exclude() {
    for u in "${utils[@]}"; do
        exclude "${_exe_mod_path}/utils.${u}.sh";
    done

    exclude "${_exe_mod_path}/aliases.sh"
}

function utils_include() {
    for u in "${utils[@]}"; do
        include_safe "${_exe_mod_path}/utils.${u}.sh";
    done;

    include_safe "${_exe_mod_path}/aliases.sh";
}

function utils_init() {
    utils_exclude;
    utils_include;
}
