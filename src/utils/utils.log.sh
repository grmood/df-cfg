function recho()    { xrep "echo -ne $1" "$2"; }
function echor()    { recho "\r" "$1"; }
function echot()    { recho "\t" "$1"; }
function echospc()  { recho " " "$1"; }
function echoln()   { recho "\n" "$1"; }
function echod()    { recho "\b" "$1"; }
function echoadel() { echod "$ARG_MAX"; }
