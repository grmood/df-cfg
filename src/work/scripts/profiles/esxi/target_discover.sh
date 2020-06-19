source env.sh

set -x

esxcli iscsi adapter discovery rediscover -A "$adapter"

set +x
