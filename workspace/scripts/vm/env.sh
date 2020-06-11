export buildDir="$HOME/build"

export kvUser="kvuser"
export kvHome="/home/$kvUser"

export vpnPath=""

export VM_BASE=sle15sp1
export VM0="$VM_BASE""-0"
export VM1="$VM_BASE""-1"
export VM1_TARGET_NAME="iqn.2020-01.script.exe:kv.target01"
export VM0_INITIATOR_NAME="iqn.2020-01.script.exe:kv.initiator01"

export p3ip="0.0.0.0"
export p3root="root@$p3ip"
export p3kv="$kvUser@$p3ip"
export p3kvHome="$p3kv:$kvHome"

# SP-0-1
export sp1host=""
export spIqn="iqn.2020-01.script.exe:sn.0000000000"

export sp1ip1=""
export sp1ip2=""
export sp1ip="$sp1ip1"

# SP-0-2
export sp2ip1=""
export sp2ip2=""
export sp2ip="$sp2ip1"

export sp1root="root@$sp1ip"
export sp2root="root@$sp2ip"

export sp1rootHome="$sp1root:/root"
export sp2rootHome="$sp2root:/root"

export spP01="$spIqn:01"
export spP02="$spIqn:02"

export iInitiatorIqn="iqn.2020-01.script.exelin:01:c1111111"
#export iInitiatorIqn="iqn.2020-01.script.exewin:win"

export PATH=$PATH:/usr/sbin




