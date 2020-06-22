# System utilities and helpers

include_safe "$_exe_mod_path/utils.log.sh"

function reexe()  { include $exedir/exe.bashrc; }
function rebash() { source $HOME/.bashrc; }
function reinit() { rebash; reexe; }

function addpath() { export PATH=$(setfd "$1:$PATH" "$PATH"); }

function own() { sudo chown -R "$USER:$USER" "$1";     }
function cwd() { echo $(cd "$(dirname "$0")" && pwd);  }
function up()  { cd $(recho '../' "$1");         }

function makejp() { make "$@" "-j$(nproc)"; }

# measure cmd runtime
function tm() {
    local start="$(date +%s)"
    $@
    local exit_code=$?
    echo >&2 "took ~$(($(date +%s)-${start})) seconds. exited with ${exit_code}"
    return $exit_code
}
