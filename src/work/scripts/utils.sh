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

_cdir() { echo "$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)"; }

logi "[ utils.sh ]: bash source --- ${BASH_SOURCE%/*}"
logi "[ utils.sh ]: cdir: $(_cdir)";

utils=(
    log str arr
    shell fs
    sys kernel os
    net git
)

for u in "${utils[@]}"; do
    include "$cdir/utils/utils.$u.sh";
done;

include "$cdir/utils/aliases.sh"
