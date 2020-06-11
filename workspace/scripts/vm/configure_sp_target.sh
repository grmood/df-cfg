#iInitiatorIqn="iqn1"
#iInitiatorIqn="iqn2"
#iInitiatorIqn="iqn2"
iInitiatorIqn=iqn3
name=vmwarejumphost

set -x

size=1.62G
drive=HDD_209.71MB

tt-cli pool create --name p1 --protection 8+2 --provision thick --size $size --drive $drive
sleep 10
tt-cli resource create block --name r1 --pool p1 --size full_pool_size
sleep 10

tt-cli resource set port --name r1 --port p01
tt-cli resource set port --name r1 --port p02
sleep 5
tt-cli host create --name $name --type iscsi --port $iInitiatorIqn
sleep 5
tt-cli resource set access --name r1 --host $name

sed -i '$ d' /root/.bashrc

set +x
