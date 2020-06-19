# ============================================
# file:     debug.sh
# project:  exedots
# author:   Konstantin Vinogradov
# email:    exescript@gmail.com
#
# File contains debug helper functions for
# other exedots scripts for beautiful output
#
# ============================================

function echotag()  {
    echo -ne "[ $1 ]\t"; shift;
    echo $@;
}

function logw()     { echotag "!" $@;   }   #warning
function loge()     { echotag "x" $@;   }   #error
function logi()     { echotag "*" $@;   }   #info
function logo()     { echotag "+" $@;   }   #ok (status)
function logf()     { echotag "-" $@;   }   #fail (for logstatus)
function logh()     { echotag "#" $@;   }   #hash (for logdbg)
function loga()     { echotag "=>" $@;  }   #arrow (list item)

function logstat() {
    (( ! "$?" )) && {
        logo -n "success";
    } ||logf -n "fail";

    [ ! -z "$@" ] && {
        echo ": { $@ }"
    } ||echo;
}

function logdbg() {
    [ -z "$EXE_DBG" ] || logh $@;
}

function log() {
    local ret="$?"

    local type="$1"; shift;
    [ -z "$type" ] && return;

    [ "$type" == "info" ]   && { logi $@; return; };
    [ "$type" == "warn" ]   && { logw $@; return; };
    [ "$type" == "err" ]    && { loge $@; return; };
    [ "$type" == "dbg" ]  && { logdbg $@; return; };
    [ "$type" == "ok" ]     && { logo $@; return; };
    [ "$type" == "fail" ]   && { logf $@; return; };
    [ "$type" == "item" ]   && { loga $@; return; };
    [ "$type" == "status" ] && {
        ( exit "$ret" ); logstat "$@";
        return;
    };
}

alias lg="log"
alias lgs="log_status"