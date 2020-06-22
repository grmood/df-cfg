function histgrep   { history | grep -i $1 ;  }
function findpkg()  { dpkg -S $(which "$1");  }
