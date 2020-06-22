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

export _utils_src_dir_="$exesrc/utils"

utils=(
    str log arr sys fs git
    shell kernel os net
)

function utils_exclude() {
    for u in "${utils[@]}"; do
        exclude "${_exe_mod_path}/utils.${u}.sh";
    done

    exclude "${_exe_mod_path}/aliases.sh"
}

function utils_include() {
    for u in "${utils[@]}"; do
        include "${_exe_mod_path}/utils.${u}.sh";
    done;

    include "${_exe_mod_path}/aliases.sh";
}

function utils_init() {
    utils_exclude;
    utils_include;
}

# utils_reinit


