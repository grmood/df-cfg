known="/home/exe/.ssh/known_hosts"
host="$1"

if [ -z "$host" ]; then
	echo "error: host required"
	exit 1
fi

ssh-keygen -f "$known" -R "$host"
