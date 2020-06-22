# Git helpers

function gcmd()     { git -C "$(setfz $2 $(pwd))" $1; }
function gclone()   { gcmd "clone $1" "$2" && cd $(basename "$1" ".git"); }
function gbranch()  { gcmd "symbolic-ref --short HEAD" "$1";    }
function gstatus()  { gcmd "status --short" "$1";               }
function gpush()    { gcmd "push origin $(gbranch) -f" "$1";    }
function gadd()     { gcmd "add --all" "$1";    }
function grm()      { git   rm --cached "$@";   }
