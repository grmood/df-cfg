set -x

user=admin
pass=asdasd
gateway=172.20.24.1

tt-cli login --user $user --password $pass
tt-cli port set --name p01 --ip1 "$sp1ip1/24" --ip2 "$sp1ip2/24" --gateway $gateway
tt-cli port set --name p02 --ip1 "$sp2ip1/24" --ip2 "$sp2ip2/24" --gateway $gateway
sleep 5

set +x

