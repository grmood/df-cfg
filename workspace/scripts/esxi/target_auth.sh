source env.sh

dir="uni"
lvl="required"

if [ ! -z "$1" ]; then
	dir="$1"
fi

if [ ! -z "$2" ]; then
	lvl="$2"
fi

set -x

esxcli iscsi adapter discovery sendtarget auth chap set -A "$adapter" -a "$target" -N $user -S $pass -l $lvl -d $dir

set +x

./target_get_auth.sh

