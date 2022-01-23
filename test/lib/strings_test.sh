#!/usr/bin/env bash
set -e
echo " * $BASH_SOURCE"
source core.sh

core.Import "core:strings.sh"
strings="core_strings"

function test_strings.Ok
{
    echo "   - test_strings.Ok"
    core_strings_Ok=0
    if [[ $($strings.Ok) != 0 || $($strings.Ok) == 1 ]];then
        echo Ok not false
        return 1
    fi

    core_strings_Ok=1
    if [[ $($strings.Ok) != 1 || $($strings.Ok) == 0 ]];then
        echo Ok not true
        return 1
    fi
}
test_strings.Ok

function test_strings.Strings
{
    echo "   - test_strings.Strings"
    core_strings_Strings=(a b c)
    local strs
    $strings.Strings strs
    for i in ${!core_strings_Strings[@]}
    do
        local s0=${core_strings_Strings[i]}
        local s1=${strs[i]}
        if [[ "$s0" != "$s1" ]];then
            echo "s0 != s1"
            echo "i=$i"
            echo "s0=$s0"
            echo "s1=$s1"
            return 1
        fi
    done 
}
test_strings.Strings

function test_strings.StartWith
{
    echo "   - test_strings.StartWith"
    local str="cerberus is an idea"
    local sub="cerberus i "
    $strings.StartWith "$str" "$sub"
    if [[ $core_strings_Ok == 1 ]];then
        echo "StartWith true"
        echo "str=\"$str\""
        echo "sub=\"$sub\""
        return 1
    fi

    sub="cerberus i"
    $strings.StartWith "$str" "$sub"
    if [[ $core_strings_Ok == 0 ]];then
        echo "StartWith false"
        echo "str=\"$str\""
        echo "sub=\"$sub\""
        return 1
    fi

    sub="cerberus"
    $strings.StartWith "$str" "$sub"
    if [[ $core_strings_Ok == 0 ]];then
        echo "StartWith false"
        echo "str=\"$str\""
        echo "sub=\"$sub\""
        return 1
    fi

    sub="cerberus "
    $strings.StartWith "$str" "$sub"
    if [[ $core_strings_Ok == 0 ]];then
        echo "StartWith false"
        echo "str=\"$str\""
        echo "sub=\"$sub\""
        return 1
    fi

    sub="cerberus  "
    $strings.StartWith "$str" "$sub"
    if [[ $core_strings_Ok == 1 ]];then
        echo "StartWith true"
        echo "str=\"$str\""
        echo "sub=\"$sub\""
        return 1
    fi
}
test_strings.StartWith

function test_strings.EndWith
{
    echo "   - test_strings.EndWith"
    local str="cerberus is an idea"
    local sub=" n idea"
    $strings.EndWith "$str" "$sub"
    if [[ $core_strings_Ok == 1 ]];then
        echo "EndWith true"
        echo "str=\"$str\""
        echo "sub=\"$sub\""
        return 1
    fi

    sub=" n idea"
    $strings.EndWith "$str" "$sub"
    if [[ $EndWith == 0 ]];then
        echo "EndWith false"
        echo "str=\"$str\""
        echo "sub=\"$sub\""
        return 1
    fi

    sub="idea"
    $strings.EndWith "$str" "$sub"
    if [[ $core_strings_Ok == 0 ]];then
        echo "EndWith false"
        echo "str=\"$str\""
        echo "sub=\"$sub\""
        return 1
    fi

    sub=" idea"
    $strings.EndWith "$str" "$sub"
    if [[ $core_strings_Ok == 0 ]];then
        echo "EndWith false"
        echo "str=\"$str\""
        echo "sub=\"$sub\""
        return 1
    fi

    sub="  idea"
    $strings.EndWith "$str" "$sub"
    if [[ $core_strings_Ok == 1 ]];then
        echo "EndWith true"
        echo "str=\"$str\""
        echo "sub=\"$sub\""
        return 1
    fi
}
test_strings.EndWith

function test_strings.Split
{
    echo "   - test_strings.Split"
    local str=",,,a,b,,cd,,ef"
    $strings.Split "$str" ",,"
    if [[ ${#core_strings_Strings[@]} != 4 ]];then
        echo Split str not equal 4
        return 1
    fi
    local s0=${core_strings_Strings[0]}
    local s1=${core_strings_Strings[1]} 
    local s2=${core_strings_Strings[2]} 
    local s3=${core_strings_Strings[3]} 
    if [[ "$s0" != "" || "$s1" != ",a,b" || "$s2" != "cd"  || "$s3" != "ef" ]];then
        echo Split 4 not match
        echo s0="\"$s0\""
        echo s1="\"$s1\""
        echo s2="\"$s2\""
        echo s3="\"$s3\""
        return 1
    fi

    local str="a b c"
    $strings.Split "$str"
    if [[ ${#core_strings_Strings[@]} != 3 ]];then
        echo Split str not equal 3
        return 1
    fi
    local s0=${core_strings_Strings[0]}
    local s1=${core_strings_Strings[1]} 
    local s2=${core_strings_Strings[2]} 
    if [[ "$s0" != "a" || "$s1" != "b" || "$s2" != "c" ]];then
        echo Split 4 not match
        echo s0="\"$s0\""
        echo s1="\"$s1\""
        echo s2="\"$s2\""
        return 1
    fi

}
test_strings.Split

function test_strings.find_files
{
    echo "   - test_strings.find_files"
    local dir=$(cd $(dirname $BASH_SOURCE) && pwd)
    local str=`find "$dir" -maxdepth 1 -name "*.ff" -type f`
    $strings.Split "$str" "
"
    if [[ ${#core_strings_Strings[@]} != 2 ]];then
        echo find files not equal 2
        return 1
    fi
    local s0=${core_strings_Strings[0]}
    local s1=${core_strings_Strings[1]}


    $strings.EndWith "$s0" "/a b.ff"
    if [[ $core_strings_Ok == 0 ]];then
        local tmp=$s0
        s0=$s1
        s1=$tmp
        $strings.EndWith "$s0" "/a b.ff"
    fi
    if [[ $core_strings_Ok == 0 ]];then
        echo "not found a b.ff"
        return 1
    fi
    $strings.EndWith "$s1" "/c.ff"
    if [[ $core_strings_Ok == 0 ]];then
        echo "not found c.ff"
        return 1
    fi
}
test_strings.find_files

function test_strings.Join
{
    echo "   - test_strings.Join"
    local strs=(a b c)
    local str=`$strings.Join strs ","`
    if [[ "$str" != "a,b,c" ]];then
        echo "Join not equal"
        echo "strs=a,b,c"
        echo "str=$str"
        return 1
    fi
}
test_strings.Join

function test_strings.Trim
{
    echo "   - test_strings.Trim"
    local s0="xxabcdexx"

    local s1=`$strings.TrimLeft "$s0" "x"`
    if [[ "$s1" != "abcdexx" ]];then
        echo TrimLeft not pass
        return 1
    fi

    local s2=`$strings.TrimRight "$s0" "x"`
    if [[ "$s2" != "xxabcde" ]];then
        echo TrimRight not pass
        return 1
    fi
   
   local s3=`$strings.Trim "$s0" "x"`
   if [[ "$s3" != "abcde" ]];then
        echo Trim not pass
        return 1
    fi
}
test_strings.Trim
