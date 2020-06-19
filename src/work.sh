# ============================================
# file:     debug.sh
# project:  exedots
# author:   Konstantin Vinogradov
# email:    exescript@gmail.com
#
# ============================================

cdir="$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)"
fenv="$cdir/work/env.sh"
futils="$cdir/work/utils.sh"

include "$fenv"
include "$futils"

export work="/home/exe/workspace"
export docs="$work/docs"

export scripts="$cdir/work/scripts"
export vpn="$cdir/work/scripts/vpn"
export src="$cdir/work/scripts/src"



