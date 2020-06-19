source env.sh

esxcli iscsi adapter discovery sendtarget auth chap get -A "$adapter" -a "$target"

