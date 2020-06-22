# ============================================
# Module: work
# 
# Workspace environment functionality
#
# ============================================

_cdir() { echo "$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)"; }

export _exe_work_workspace_default="$HOME/workspace2"

export fenv="$work/env.sh"
export futils="$work/utils.sh"
export docs="$work/docs"
export scripts="$work/scripts"
export src="$work/scripts/src"
export build=$work/build

function workspace_init() {
    local work="$1"
    local work_dirs=( build logs tmp profiles bin lib scripts )

    dbg "work: workspace dir: $work"

    [ ! -d $work ] && {
        xquiet "mkdir $work";
        logstat "work: create workspace '$work/$d'";
    }

    for d in "${work_dirs[@]}"; do
        if [ ! -d "$work/$d" ]; then
            mkdir "$work/$d";
            logstat "work: create $work/$d";
        fi
    done
}

function work_include() {
    workspace_init "$_exe_work_workspace_default";
}

function work_exclude() {
    dbg "work: exclude";
}

function work_init() {
    dbg "work: init";
}

function work_run() {
    dbg "work: run";
}

function work_help() {
    dbg "work: help";
}
