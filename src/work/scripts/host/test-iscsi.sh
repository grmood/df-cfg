source $work/env.sh

dev="$1"
dev_default="/dev/sdb"

if [ -z "$dev" ]; then
	dev="$dev_default"
fi

sudo sg_write_same -v --16 --lba 16 --num 16 $dev
sudo sg_write_same -v --32 --lba 0 --num 16 $dev
sudo sg_write_same -v --32 --lba 16 --num 16 $dev

