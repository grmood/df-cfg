source $work/utils.sh

export user=tt
export pass=asdasd12345
export auth=CHAP

export iqn1=iqn.2017-01.com.exe:sn.010218a24b0ct1:p01
export iqn2=iqn.2017-01.com.exe:sn.010218a24b0ct1:p02

export ip1=$sp1ip
export ip2=$sp2ip

iscsi_db_target_set "$ip1"
iscsi_db_target_set "$ip2"

iscsi_db_target_discover "$ip1"
iscsi_db_target_discover "$ip2"

iscsi_node_target_set "$ip1" "$iqn1"
iscsi_node_target_set "$ip2" "$iqn2"

iscsi_node_target_logout "$iqn1"
iscsi_node_target_logout "$iqn2"

iscsi_node_target_login "$iqn1"
iscsi_node_target_login "$iqn2"

