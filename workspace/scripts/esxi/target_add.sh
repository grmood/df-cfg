source env.sh

set -x

esxcli iscsi adapter discovery sendtarget add -A "$adapter" -a "$target"

set +x

