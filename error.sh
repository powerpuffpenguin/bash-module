#!/usr/bin/env bash

# check $?
#
# * $1 ? error message
function pppg_check_error(){
    local code=$?
    if [[ $code != 0 ]];then
        if [[ "$1" == "" ]];then
            echo "exit $code"
        else
            echo "exit $code, $1"
        fi
        exit $code
    fi
}