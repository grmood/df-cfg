export buildDir="$HOME/build"

export kvUser="k.asdpfjsf"
export kvHome="/home/$kvUser"

export vpnPath="$work/scripts/vpn/k.asdpfjsf-vpn01"

export VM_BASE=kasdpfjsf-sle15sp1
export VM0="$VM_BASE""-0"
export VM1="$VM_BASE""-1"
export VM1_TARGET_NAME="iqn.2020-01.com.exe:kasdpfjsf.target01"
export VM0_INITIATOR_NAME="iqn.2020-01.com.exe:kasdpfjsf.initiator01"

export p3ip="0.0.0.0"
export p3root="root@$p3ip"
export p3kv="$kvUser@$p3ip"
export p3kvHome="$p3kv:$kvHome"

# SP-0-1
export sp1host="$kvUser-storage-processor-00.xxx.ttt.exe.com"
export spIqn="iqn.2017-01.com.exe:sn.010218a24b0ct1"

export sp1ip1="0.0.0.2"
export sp1ip2="0.0.0.4"
export sp1ip="$sp1ip1"

# SP-0-2
export sp2ip1="0.0.0.0"
export sp2ip2="0.0.0.1"
export sp2ip="$sp2ip1"

export sp1root="root@$sp1ip"
export sp2root="root@$sp2ip"

export sp1rootHome="$sp1root:/root"
export sp2rootHome="$sp2root:/root"

export spP01="$spIqn:p01"
export spP02="$spIqn:p02"

export iInitiatorIqn="iqn1"
#export iInitiatorIqn="iqn2"

export PATH=$PATH:/usr/sbin




