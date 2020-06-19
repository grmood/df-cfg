# ============================================
# file:     work.sh
# project:  exedots
# author:   Konstantin Vinogradov
# email:    exescript@gmail.com
#
# ============================================

cdir="$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)"
export fenv="$cdir/work/env.sh"
export futils="$cdir/work/utils.sh"

include "$fenv"
include "$futils"

export work="$HOME/workspace"
export docs="$work/docs"
export scripts="$work/scripts"
export src="$work/scripts/src"
export build=$work/build
	

