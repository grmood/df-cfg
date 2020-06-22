# ============================================
# Module: work
# 
# Workspace environment functionality
#
# ============================================

_cdir() { echo "$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)"; }

export work="$HOME/workspace"

export fenv="$work/env.sh"
export futils="$work/utils.sh"

function work_include() {
	dbg "Workspace user directory: '$work'"

	[ -d $work ] || {
	    dbg "Workspace directory doesn't exist"
	    dbg "Create workspace directory : '$work'"

	    xquiet "mkdir $work" ||
	        fatal "1" "make workspace failed: '$work'";
	}

	
	for d in "${work_dirs[@]}"; do
	    [ ! -d $work/$d ] && {
	        dbg "Make workspace subdirectory: '$d' ";
	        ( ! mkdir $work/$d ) && logf || logo;
	    } || dbg "exedots: workspace subdirectory '$work/$d' already exists";
	done
}

function work_exclude() {
	dbg "work: exclude"
}

export docs="$work/docs"
export scripts="$work/scripts"
export src="$work/scripts/src"
export build=$work/build
	

