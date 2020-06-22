export dnsfile="/etc/resolvconf/resolv.conf.d/head"

# Net shortcuts
function wifikeys() { sudo grep -r '^psk=' /etc/NetworkManager/system-connections/; } 
function sniff()    { sudo lsof -Pan -i tcp -i udp; }
function wzr()      { curl "http://wttr.in;";    }
function wzr2day()  { curl "http://v2.wttr.in;"; }

# SSH helpers
function ssh_addr()   { LANG=C xloop "ssh $1; sleep 5;";  }
function ssh_dmesg()  { ssh_addr "$1" "dmesg -w"; }
function ssh_forget() { ssh-keygen -f "$HOME/.ssh/known_hosts" -R "$@"; }
function ssh_setup() {
    ssh $1 'mkdir -p -m 700 .ssh; touch .ssh/authorized_keys; chmod 600 .ssh/authorized_keys';
    cat ~/.ssh/id_rsa.pub | ssh $1 'cat - >> ~/.ssh/authorized_keys'
}

function ssh_tcpdump() {
    local filter=$(setfnz "$2" "-Y $2")
    ssh "$1" tcpdump -i any -U -s0 -w - 'not port 22' |  wireshark $filter -k -i -
}

function ssh_tcpdump_in() {
    local filter=$(setfnz "$2" "-Y $2")
    local host=${1##*@}
    local net=$(ipcalc -b $p3vm1 | grep Network)

    net=`echo $net | awk '{print $NF}'`
    ssh "$1" "tcpdump -i any -U -s0 -w - 'not port 22' and dst host $host and not src net $net" | wireshark $filter -k -i -
}
