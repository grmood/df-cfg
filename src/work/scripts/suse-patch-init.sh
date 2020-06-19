#!/usr/bin/env bash

. $work/env.sh

function _quilt_patch() {
	echo "[ * ] Patching kernel tree by patch series ..."
	./scripts/sequence-patch.sh --quilt --fast && echo "[ + ] Patch creation succeed" || echo "[ X ] Patching failed: ['$?']"
}

function _kernel_build() {
	local tree=$(set_ifz "$1" "$ktree")

	echo -ne "[ * ] Running silentoldconfig ..."
	exec_on "./cc-opensuse.sh silentoldconfig" "$tree" --quiet && echo -e "\t[ OK ]" || echo -e "\t[ FAILED ]";

	echo "[ * ] Building kernel tree :"
	exec_on "./cc-opensuse.sh" "$tree" && echo -e "[ Build succeed ]" || echo -e "[ Build failed ]: $?";
}

function _git_init() {
	local tree=$(set_ifz "$1" "$ktree")

	echo -ne "[ * ] Updating git index ..."
	exec_on "git add --all" "$tree" --quiet && echo -e "\t[ OK ]" || echo -e "\t[ FAILED ]";

	echo -ne "[ * ] Preparing git commit ..."
	exec_on "git commit -m 'base commit'" "$tree" --quiet && echo -e "\t[ OK ]" || echo -e "\t[ FAILED ]";
}

patch_name=$(set_ifz "$1" "patches/patches.yadro/0001-$(mkdate).patch")
echo "[ => ] Initializing patch: $patch_name"

ktree="$(pwd)/tmp/current"
echo "[ # ] Kernel tree: $ktree"

ver_file="$(pwd)/current.ver.txt"

[ -f "$ver_file" ] && ver_current=$(cat "$ver_file");

uri="$sp1root"
cont=yes;

msg="[ * ] Kernel version detection ..."
echo -ne "$msg"
ver=$(kver "$uri")
if [ -z "$ver" ]; then
    echo -ne "\n\t[ # ] Could not recieve kernel version from ['$uri']: $?\n$msg"
    [ ! -z "$ver_current" ] && ver="$ver_current" || (echo -en "\t[ FAILED ] < No default kernel version found in $ver_file >\n$msg" && exit 1);
else
	echo -ne "\n[ # ] Updating version in ['$ver_file'] ..."
    echo "$ver" > "$ver_file"
    [ $? -eq 0 ] && echo -ne "\t[ OK ]\n$msg" || echo -ne "\t[ FAILED ]: $?\n$msg"
fi

echo -e "\t[ OK ]"
echo "[ # ] Kernel version: $ver"

git reset --hard

[ "$cont" == "yes" ] ||  _quilt_patch;

mkdir -p ./tmp

echo -ne "[ * ] Preparing kernel tree build scripts ..."
[ -f "./cc-opensuse.sh" ] || cp -u "$hscripts/cc-opensuse.sh" "$ktree/"
[ -f "./rsync_all" ] || cp "$hscripts/rsync_all.sh" "$ktree/"
echo -e "\t[ OK ]"

echo -ne "[ * ] Downloading kernel config from $uri ..."
exec_on "kcfg $uri" "$ktree" --quiet && echo -e "\t[ OK ]" || echo -e "\t[ FAILED ]";

[ "$build" == "yes" ] && _kernel_build;

_git_init;

exec_on "quilt new $patch_name" "$ktree" --quiet
echo "[ => ] Patch successfullt initialized: ['$patch_name']"

