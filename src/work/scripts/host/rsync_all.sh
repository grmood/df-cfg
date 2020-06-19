#!/usr/bin/env bash
. $work/env.sh
. $work/utils.sh

user=root

sp1uri=$user@$sp1ip1
sp2uri=$user@$sp1ip2

kver1=$(kver $sp1uri)
kver2=$(kver $sp2uri)

kdir=./linux-4.12
mdir1=/lib/modules/$kver1
mdir2=/lib/modules/$kver2

sp1udir="$sp1uri:$mdir1/updates"
sp2udir="$sp2uri:$mdir2/updates"

function modsync() {
	local src="$1"

	rsync -av $(find $src -name '*.ko') $sp1udir
	rsync -av $(find $src -name '*.ko') $sp2udir
}

function tsync() {
	local tblock="$1"
	scp $tblock $sp1udir
	scp $tblock $sp2udir
}

tblock=./target_tt_tblock.ko

modsync "$kdir/drivers/target"
modsync "$kdir/drivers/scsi/qla2xxx"
tsync "$tblock"

ssh $sp1uri 'mount /dev/md127p2 /boot; depmod -a && dracut --force && reboot'
ssh $sp2uri 'mount /dev/md127p2 /boot; depmod -a && dracut --force && reboot'


