#!/usr/bin/env bash

# include package
function pppg_include(){
    local dirname=$(cd $(dirname $BASH_SOURCE) && pwd)
    local i=1
    for ((;i<=$#;i=i+1))
    do
        eval path=\$$i
        . "$dirname/$path"
    done
}