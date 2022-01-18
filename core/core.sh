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
    if [[ "$1" == "" ]];then
        Error "Error: Import(\"\")"
        ErrorStack 1
        return 1
    fi
    declare -i length=${#1}
    if [[ length > 5 && "${1::5}" == "core:"  ]];then
        local dir=$(cd $(dirname $BASH_SOURCE) && pwd)
        local path="$dir/lib/${1:5}"
        __ImportImpl "$path" "$1"
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
    __ImportImpl "$dir/$1" "$1"
    return $?
}

function __ImportImpl
{
    local ErrExit=0
    if [[ $- == *e* ]];then
        ErrExit=1
        set +e
    fi
    source "$1"  1>&2
    local result=$?
    if [[ $result != 0 ]];then
        Error "Error: Import(\"$2\")"
        ErrorStack 1
    fi
    if [[ "${ErrExit}" == 1 ]]; then
        set -e
    fi
    return $result
}

# copy array, set arr0=arr1
#
# func Copy(arrName0: string, arrName1: string)
function Copy
{
    if [[ "$1" == "" || "$2" == "" ]];then
        Error "Error: Copy($1, $2)"
        ErrorStack 1
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
        Error "Error: Copy($1, $2)"
        ErrorStack 1
    fi
    if [[ "${ErrExit}" == 1 ]]; then
        set -e
    fi
    return $result
}

# func GetField(object: string, i: number)
function GetField
{
    eval "echo \${$1[$2]}"
}
# func SetField(object: string, i: number, value: any)
function SetField
{
    eval "$1[$2]=\"$3\""
}
# func Field(object: string, i: number, value?: any)
function Field
{
    case ${#@} in
        0|1)
            Error "Error: call ${FUNCNAME[1]} missing self"
            ErrorStack 2
            return 1
        ;;
        2) # get
            GetField "$1" "$2"
            if [[ $? != 0 ]];then
                Error "Error: call ${FUNCNAME[1]} has an error"
                ErrorStack 2
            fi
        ;;
        *)
            SetField "$1" $2 "$3"
            if [[ $? != 0 ]];then
                Error "Error: call ${FUNCNAME[1]} has an error"
                ErrorStack 2
            fi
        ;;
    esac
}

# echo to stderror
function Error
{
    echo "$@" 1>&2
}
# echo stack to stderror
function ErrorStack
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