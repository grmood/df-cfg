export exedir="$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)";
export execfg="$exedir/cfg"
export exesrc="$exedir/src"

# include print helpers
source "$exesrc/debug.sh"

function include() {
 	local ret

 	[ ! -f "$1" ] && {
 		ret=$?; logdbg "file doesn't exist: '$1'";
 		return $ret;
 	} || {
 		logdbg "=> $1";
 		. "$1";
 		logdbg "<= $1";
 	}
}

dtests="$exedir/tests"
drc="$exedir/rc.d"

# include main modules
include "$exesrc/common.sh"
include "$exesrc/work.sh"

# include user modules
include "$exesrc/.private.sh"
for rc in $drc/* ; do include $rc; done;

# uncomment line to enable
# log 'dbg' message type printing
# export EXE_DBG=y
