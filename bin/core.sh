#!/usr/bin/env bash
# api
# * english https://github.com/powerpuffpenguin/bash_module/tree/main/document/en/README.md
# * zh_Hant https://github.com/powerpuffpenguin/bash_module/tree/main/document/zh_Hant/README.md

if [[ "$__module_flag_of_core" == 1 ]];then
    return 0
fi
__module_flag_of_core=1

core_Version="v0.1.0"
# return current version
#
# func Version(): string
function core.Version
{
    echo -n "$core_Version"
}

# import a module
#
# func Import(path: string)
#
# path should be a relative path to the current script
function core.Import
{
    if [[ "$1" == "" ]];then
        core.Error "Error: import(\"\")"
        core.ErrorStack 1
        return 1
    fi
    declare -i length=${#1}
    if [[ length > 5 && "${1::5}" == "core:"  ]];then
        local dir=$(cd $(dirname $BASH_SOURCE) && pwd)
        local path="$dir/core.libs/${1:5}"
        core._import "$path" "$1"
        return $?
    fi
    # local caller=`caller`
    # local str
    # while true
    # do
    #     str=${caller#[0-9]}
    #     if [[ "$str" == "$caller" ]];then
    #         break
    #     fi
    #     caller=$str
    # done
    # local dir=$(cd $(dirname $caller) && pwd)
    local dir=$(cd $(dirname ${BASH_SOURCE[1]}) && pwd)
    core._import "$dir/$1" "$1"
    return $?
}
function core._import
{
    local ErrExit=0
    if [[ $- == *e* ]];then
        ErrExit=1
        set +e
    fi
    source "$1"  1>&2
    local result=$?
    if [[ $result != 0 ]];then
        core.Error "Error: import(\"$2\")"
        core.ErrorStack 1
    fi
    if [[ "${ErrExit}" == 1 ]]; then
        set -e
    fi
    return $result
}

# copy array, set arr0=arr1
#
# func Copy(arrName0: string, arrName1: string)
function core.Copy
{
    if [[ "$1" == "" || "$2" == "" ]];then
        core.Error "Error: Copy($1, $2)"
        core.ErrorStack 1
        return 1
    fi

    local ErrExit=0
    if [[ $- == *e* ]];then
        ErrExit=1
        set +e
    fi
    eval "$1=(\"\${$2[@]}\")" 1>&2
    local result=$?
    if [[ $result != 0 ]];then
        core.Error "Error: Copy($1, $2)"
        core.ErrorStack 1
    fi
    if [[ "${ErrExit}" == 1 ]]; then
        set -e
    fi
    return $result
}

# func GetField(object: string, i: number)
function core.GetField
{
    eval "echo \${$1[$2]}"
}
# func SetField(object: string, i: number, value: any)
function core.SetField
{
    eval "$1[$2]=\"$3\""
}
# func Field(object: string, i: number, value?: any)
function core.Field
{
    case ${#@} in
        0|1)
            core.Error "Error: call ${FUNCNAME[1]} missing self"
            core.ErrorStack 2
            return 1
        ;;
        2) # get
            core.GetField "$1" "$2"
            if [[ $? != 0 ]];then
                core.Error "Error: call ${FUNCNAME[1]} has an error"
                core.ErrorStack 2
            fi
        ;;
        *)
            core.SetField "$1" $2 "$3"
            if [[ $? != 0 ]];then
                core.Error "Error: call ${FUNCNAME[1]} has an error"
                core.ErrorStack 2
            fi
        ;;
    esac
}

# echo to stderror
function core.Error
{
    echo "$@" 1>&2
}
# echo stack to stderror
function core.ErrorStack
{
    declare -i i=1
    if [[ $1 > 0 ]];then
        i=$1
        i=i+1
    fi
    local n=${#FUNCNAME[@]}
    for ((; i<$n ; i++ )); do
        local func="${FUNCNAME[$i]}"
        local line="${BASH_LINENO[(( i - 1 ))]}"
        local file="${BASH_SOURCE[$i]}"
        echo "    at $func ($file:$line)"
    done
}