#!/usr/bin/env bash

# get user input
# 
# * $1 placeholder text
# * $2 ? default value
function pppg_stdin_scan(){
    local placeholder=$1
    local default=$2
    if [[ "$placeholder" == "" ]]; then
        placeholder="please input value"
    fi

    if [[ "$default" != "" ]]; then
        placeholder="please input value ($default)"
    fi

    while true
    do
        local result
        read -p "$placeholder: " result

        local code=$?
        if [[ "$code" != 0 ]]; then
            return $code
        fi

        if [[ "$result" != "" ]]; then
            echo "$result"
            break
        fi

        if [[ "$default" != "" ]]; then
            echo "$default"
            break
        fi
    done
}