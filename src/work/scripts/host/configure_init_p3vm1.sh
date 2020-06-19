#source $work/env.sh

#export iqn=iqn.2017-01.com.exe:sn.010218a24b0ct1
export ip=$p3vm1

function iscsi_db_target_discover() {
	local ip="$1"
	sudo iscsiadm -m discoverydb -p $ip -t st -D
}

function iscsi_node_target_set() {
	local ip="$1"
	local iqn="$2"
	sudo iscsiadm -m node -T $iqn -p $ip -o update -n node.session.auth.username -v $user
	sudo iscsiadm -m node -T $iqn -p $ip -o update -n node.session.auth.password -v $pass
}

function iscsi_node_target_login() {
	local iqn="$1"
	sudo iscsiadm -m node -T $iqn -u 2>/dev/null
	sleep 1
	sudo iscsiadm -m node -T $iqn -l
}

set -x

iqn=`iscsi_db_target_discover $ip`
iqn=${iqn##* }

iscsi_node_target_set $ip $iqn
iscsi_node_target_login $iqn

set +x
