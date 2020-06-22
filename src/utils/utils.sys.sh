include_safe "$_exe_mod_path/utils.log.sh"

function drop_caches() {
	free; sync;
	echo 3 > /proc/sys/vm/drop_caches; free;
}

function witer {
    eval $@;
    (( ! "$?" )) || {
        loge "watch iteration error";
        return 1;
    }

    sleep 1; echor;
}

function wcmd()    { xloop "echo_iterate $@"; }
function wuptime() { wcmd 'echo -ne "Uptime: $(uptime --pretty)"';           }
function wsize()   { wcmd 'echo -ne $(sudo du -h -s -X '"$fexcludes $1"')';  }
function wmem()    { wcmd 'echo -ne $(cat /proc/meminfo | grep -i memfree)'; }

# list users (based on /etc/passwd)

function lsusers() {
    local fmt="%-20s %-7s %-7s %-28s %s\n"
	printf "$fmt" "USERNAME" "UID" "GID" "HOME" "SHELL"

	while IFS=':' read -r user pass uid gid uext home shell
    do
		if [ "$1" == "--nosys" ]; then
            if [[ "$shell" == *"/nologin" ]] || [[ "$shell" == *"/false" ]] ||
                [[ "$home" == *"/bin" ]] || [[ "$home" == *"/sbin" ]]; then
                continue
            fi
        fi
		printf "$fmt" "$user" "$uid" "$gid" "$home" "$shell"
	done < /etc/passwd
}

# Base64
function en64 () { echo "$1" | base64 -d; echo; }
function de64 () { echo "$1" | base64;    echo; }
