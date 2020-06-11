source $work/env.sh

host="$sp1ip"
user="tt"
pass="asdasd12345"

tt-cli system set iscsi user --name $user --password $pass

