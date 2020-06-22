function squo()  { echo -ne "'$*'";  }
function dquo()  { echo -n "\"$@\""; }

function fword() { echo "${1%% *}"; }
function lword() { echo "${1##* }"; }

function strlow()   { echo "$@" | tr A-Z a-z; }
function strhigh()  { echo "$@" | tr a-z A-Z; }
