# Find array index
function lookup() {
    local val="$1"; shift;
    local arr=("$@"); 
    local cnt=${#{arr[@]}};

    for i in $(seq 0 "$(( $cnt - 1 ))"); do
    	[ ! "${arr[$i]}" == "$val" ] &&
            continue;

    	echo "$i";
        return;
    done
}
