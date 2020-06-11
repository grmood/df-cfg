#!/usr/bin/env bash

. $fenv
. $futils

ver=kver $sp1root
rsync -av $(find drivers/target -name '*.ko') $sp1root:/lib/modules/$kver/updates && ssh $sp1root "depmod && reboot"
