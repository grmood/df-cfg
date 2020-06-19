source env.sh
set -x

esxcli iscsi adapter discovery sendtarget remove -A "$adapter" -a "$target"

set +x
