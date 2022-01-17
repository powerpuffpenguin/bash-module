#!/usr/bin/env bash

if [[ "$__module_flag_of_core" == 1 ]];then
    return 0
fi
__module_flag_of_core=1


# import a module
#
# func Import(path: string)
#
# path should be a relative path to the current script
function Import
{
    local caller=`caller`
    local str
    while true
    do
        str=${caller#[0-9]}
        if [[ "$str" == "$caller" ]];then
            break
        fi
        caller=$str
    done
    local dir=$(cd $(dirname $caller) && pwd)
    source "$dir/$1"
}

# define a Class
#
# func Class(fullname: string)
#
# should eval `$Class "fullname"`
function Class
{
    echo "$1.get(){ echo \$1'=(\"\${$1[@]}\")';}"
    echo "$1.set(){ echo '$1=(\"\${'\$1'[@]}\")';}"
}