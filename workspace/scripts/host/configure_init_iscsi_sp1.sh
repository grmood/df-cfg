#source $work/env.sh

export user=tt
export pass=asdasd12345
export auth=CHAP
export iqn=iqn.2017-01.com.exe:sn.010218a24b0ct1

function iscsi_db_target_set() {
	local ip="$1"
	sudo iscsiadm -m discoverydb -p $ip -t st -o new
	sudo iscsiadm -m discoverydb -p $ip -t st -o update -n discovery.sendtargets.auth.authmethod -v $auth
	sudo iscsiadm -m discoverydb -p $ip -t st -o update -n discovery.sendtargets.auth.username -v $user
	sudo iscsiadm -m discoverydb -p $ip -t st -o update -n discovery.sendtargets.auth.password -v $pass
}

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

iscsi_db_target_set $sp1ip1
iscsi_db_target_set $sp1ip2

iscsi_db_target_discover $sp1ip1
iscsi_db_target_discover $sp1ip2

iscsi_node_target_set $sp1ip1 "$iqn:p01"
iscsi_node_target_login "$iqn:p01"

iscsi_node_target_set $sp1ip2 "$iqn:p02"
iscsi_node_target_login "$iqn:p02"

set +x
