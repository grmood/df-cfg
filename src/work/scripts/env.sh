include $futils

# external links
export KERNEL_GIT="https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git"
export KERNEL_CDN="https://cdn.kernel.org/pub/linux/kernel"

function kernel_clone() {
	branch="$1"
	git clone $KERNEL_GIT -b "$branch" ./linux-$branch
}

function kernel_gettarball() {
	local version="$1"
	local dir="$2"

	if [ -z "$dir" ]; then
		dir=`pwd`
	fi

	local major="${version%%.*}"
	local uri="$KERNEL_CDN/v$major.x/linux-$version.tar.xz"

	wget --show-progress --directory-prefix="$dir" "$KERNEL_CDN/v$major.x/linux-$version.tar.xz"

}

function ssh_addr() {
        local addr="$1"
	local cmd="$2"
        while true
        do
                LANG=C ssh "$addr" "$cmd"
                sleep 5
        done
}

function ssh_exe() {
	local addr="$1"
	local cmd="$2"
	local opt1="AddKeysToAgent yes"
	local opt2="StrictHostKeyChecking no"
	ssh $addr $cmd
	res=$?
	while [ ! $res -eq "0" ]; do
		ssh $addr $cmd 2>/dev/null
		res=$?
		echo "res: $res"
	done
}

function ssh_reboot() {
	local addr="$1"
	ssh_exe "$1" "reboot"
}

function ssh_addr() {
	local addr="$1"
	while true
	do
		LANG=C99 ssh $addr
		sleep 5
	done
}

function iscsi_gen_iqn() {
	local iqnDate=$(date + "%Y-%m")
	local iqnDom="exe.script"
	local iqnStor="01:zx9hnwe"
	echo "iqn.$iqnDate.$iqnDom:$iqnStor"
}

function ssh_tcpdump_in() {
	local addr="$1"
	local filter="$2"

	local host=${addr##*@}
	local net=`ipcalc -b $p3vm1 | grep Network`

	if [ ! -z $filter ]; then
		local filter_opt="-Y $filter"
	fi

	net=`echo $net | awk '{print $NF}'`
        ssh "$addr" "tcpdump -i any -U -s0 -w - 'not port 22' and dst host $host and not src net $net" |  wireshark $filter_opt -k -i -
}

function ssh_tcpdump() {
	local addr="$1"
	local filter="$2"

	if [ ! -z $filter ]; then
		local filter_opt="-Y $filter"
	fi

	ssh "$addr" tcpdump -i any -U -s0 -w - 'not port 22' |  wireshark $filter_opt -k -i -
}

export PATH=$PATH:/usr/sbin

