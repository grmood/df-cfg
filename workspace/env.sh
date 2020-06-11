source $work/utils.sh

export buildDir="$HOME/build"

export kvUser="kvuser"
export kvHome="/home/$kvUser"

export scripts="$work/scripts"
export vpn="$scripts/vpn/k.vinogradov-vpn01"
export src="$work/src"
export docs="$work/docs"

export fenv="$work/env.sh"
export futils="$work/utils.sh"

export VM_BASE=sle15sp1
export VM0="$VM_BASE""-0"
export VM1="$VM_BASE""-1"
export VM1_TARGET_NAME="iqn.2020-01.exe.script:target01"
export VM0_INITIATOR_NAME="iqn.2020-01.exe.script:initiator01"

export p3ip="0.0.0.0"
export p3root="root@$p3ip"
export p3kv="$kvUser@$p3ip"
export p3kvHome="$p3kv:$kvHome"

# SP-0-1
export sp1host="$kvUser-storage-processor-00.exe.script"
export spIqn="iqn.2020-01.exe.script:sn.000001"

export sp1ip1="1.1.1.1"
export sp1ip2="2.2.2.2"
export sp1ip="$sp1ip1"

# SP-0-2
export sp2ip1="3.3.3.3"
export sp2ip2="4.4.4.4"
export sp2ip="$sp2ip1"

export sp1root="root@$sp1ip"
export sp2root="root@$sp2ip"

export sp1rootHome="$sp1root:/root"
export sp2rootHome="$sp2root:/root"

export spP01="$spIqn:01"
export spP02="$spIqn:02"

export p3vm1="5.5.5.5"
export p3vm2="6.6.6.6"

export p3subnet="8.8.8.0/24"

export p3vm1root=root@$p3vm1
export p3vm2root=root@$p3vm2

export iInitiatorIqn="iqn.2020-01.exe.script:01:ca00000"
export iWinIqn="iqn.2020-01.win.script::win"

export esx1="9.9.9.9"
export esx2="10.10.10.10"

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

function ssh_sp1exe() {
	local cmd="$1"
	ssh_exe "$sp1root" "$cmd"
}

function ssh_esx1() {
	ssh_addr "root@$esx1"
}

function ssh_esx2() {
	ssh_addr "root@$esx2"
}

function ssh_addr() {
	local addr="$1"
	while true
	do
		LANG=C99 ssh $addr
		sleep 5
	done
}

function ssh_p3root() {
	ssh_addr $p3root
}

function ssh_p3kv() {
	ssh_addr $p3kv
}

function ssh_sp1root() {
	ssh_addr $sp1root
}

function ssh_sp1host() {
	ssh_addr "$sp1host"
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

function tcpdump_sp1() {
	local filter="$1"
	ssh_tcpdump "root@$sp1ip1" "$filter"
}

function tcpdump_sp2() {
	local filter="$1"
	ssh_tcpdump "root@$sp1ip2" "$filter"
}

function tcpdump_p3vm1() {
	local filter="$1"
	ssh_tcpdump "$p3vm1root" "$filter"
}

function tcpdump_p3vm2() {
	local filter="$1"
	ssh_tcpdump "$p3vm2root"
}

function stor_open() {
	local stor="$1"
	firefox ""
}

alias se="sudo echo"

export PATH=$PATH:/usr/sbin

