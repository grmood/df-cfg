source $work/utils.sh

mnt_path="/mnt1"
dm_dev="/dev/dm-0"

iqn1="iqn.2017-01.com.exe:sn.010218a24b0ct1:p01"
iqn2="iqn.2017-01.com.exe:sn.010218a24b0ct1:p02"

mkdir -p "$mnt_path"
umount "$mnt_path" 2>/dev/null

iscsi_node_target_logout "$iqn1"
iscsi_node_target_logout "$iqn2"

iscsi_node_target_login "$iqn1"
iscsi_node_target_login "$iqn2"

yes | sudo mkfs.ext4 "$dm_dev"
sudo mount "$dm_dev" "$mnt_path"
