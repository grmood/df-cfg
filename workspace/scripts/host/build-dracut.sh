#!/bin/bash
set -x
export LIBVIRT_DEFAULT_URI='qemu:///system'
if [ -z $1 ]; then
	>2 echo Please specify base VM
	exit 1
fi
if [ -z $2 ]; then
	>2 echo Please specify VM root
	exit 1
fi
if [ -z $3 -o ! -d $3 ]; then
	>2 echo Please specify the kernel tree
	exit 1
fi
VM="$1"
ROOT=~/override/$VM
BOOT=$ROOT/boot
IMGDIR=/var/lib/libvirt/images
rm -f $BOOT/vmlinuz-* $BOOT/initrd-*
rm -r $ROOT
mkdir -p $BOOT
INSTALL_PATH=$BOOT make -C "$3" install
INSTALL_MOD_PATH=$ROOT make -C "$3" modules_install
kernel=$(realpath $BOOT/vmlinuz-*)
version=${kernel#"$BOOT/vmlinuz-"}
initrd=$BOOT/initrd-$version
dracut -k $ROOT/lib/modules/$version -N $initrd $version
ln -s $initrd $BOOT/initrd
ln -s $kernel $BOOT/kernel
virsh destroy $VM
sudo qemu-img create -f qcow2 -b $IMGDIR/$VM.qcow2 $IMGDIR/$VM-custom-kernel.qcow2
sudo guestfish add $IMGDIR/$VM-custom-kernel.qcow2 : run : mount $2 / : copy-in $ROOT/lib / : copy-in $ROOT/boot /
virsh start $VM --console
