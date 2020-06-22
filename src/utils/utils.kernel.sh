# kernel helpers and constants

export kgit="https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git"
export kcdn="https://cdn.kernel.org/pub/linux/kernel"

function kver() { echo $(ssh "$1" "cd /lib/modules; ls -1dvr [0-9]* | head -1" 2>/dev/null); }
function kcfg() {
    local ver=$(setfz "$2" "$(kver $1)") 
    scp $1:/boot/config-$ver ./.config
}

function kclone() {
    local branch=$(setfz "$1" "master")
    local dst=$(setfz "$2" "./linux-$branch")

    git clone "$kgit" -b "$branch" "$dst";
}

function ktarball() {
    local version="$1"
    local dir=$(setfz "$2" "$(pwd)")

    local major="${version%%.*}"
    local uri="$kcdn/v$major.x/linux-$version.tar.xz"

    wget --show-progress --directory-prefix="$dir" "$kcdn/v$major.x/linux-$version.tar.xz"
}
