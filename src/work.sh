# ============================================
# Module: work
# 
# Workspace environment functionality
#
# ============================================

_cdir() { echo "$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)"; }

export work="$HOME/workspace"

export fenv="$(_cdir)/env.sh"
export futils="$(_cdir)/utils.sh"

# logi "[ work.sh ] cdir : $(_cdir)"

function work_include() {
	dbg "work: include"
}

function work_exclude() {
	dbg "work: exclude"
}

export docs="$work/docs"
export scripts="$work/scripts"
export src="$work/scripts/src"
export build=$work/build
	

