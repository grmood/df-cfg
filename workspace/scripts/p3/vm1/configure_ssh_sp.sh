source $work/env.sh

host=$1
iqn=$2
sp=$3

if [ -z "$sp" ]; then
	sp=$sp1ip
fi

if [ -z "$host" ]; then
	echo "warning: host required"
	echo "warning: Using default hostname: $sp1host"
	host="$sp1host"
fi

cmd_host="/root/configure_sp_target_base.sh"
cmd_append="echo 'source /root/configure_sp_target.sh' >> /root/.bashrc"

if [ ! -z "$iqn" ]; then
	cmd_append="echo 'export iInitiatorIqn=$iqn' >> /root/.bashrc; sleep 10; $cmd_append"
fi


cmd_host="$cmd_host && $cmd_append"
host=root@$host
./forget-sp.sh

scp ./.bashrc ./* $host:/root
ssh $host "$cmd_host && reboot"


