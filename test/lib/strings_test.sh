#!/usr/bin/env bash
set -e
echo " * $BASH_SOURCE"
source core.sh

Import "core:strings.sh"
strings="core_strings"
Files="core_strings_Files"
function test_strings.start_with
{
    echo "   - test_strings.start_with"
    local str="cerberus is an idea"
    local sub="cerberus i "
    $strings.start_with "$str" "$sub"
    if [[ $core_strings_Ok == 1 ]];then
        echo "start_with true"
        echo "str=\"$str\""
        echo "sub=\"$sub\""
        return 1
    fi

    sub="cerberus i"
    $strings.start_with "$str" "$sub"
    if [[ $core_strings_Ok == 0 ]];then
        echo "start_with false"
        echo "str=\"$str\""
        echo "sub=\"$sub\""
        return 1
    fi

    sub="cerberus"
    $strings.start_with "$str" "$sub"
    if [[ $core_strings_Ok == 0 ]];then
        echo "start_with false"
        echo "str=\"$str\""
        echo "sub=\"$sub\""
        return 1
    fi

    sub="cerberus "
    $strings.start_with "$str" "$sub"
    if [[ $core_strings_Ok == 0 ]];then
        echo "start_with false"
        echo "str=\"$str\""
        echo "sub=\"$sub\""
        return 1
    fi

    sub="cerberus  "
    $strings.start_with "$str" "$sub"
    if [[ $core_strings_Ok == 1 ]];then
        echo "start_with true"
        echo "str=\"$str\""
        echo "sub=\"$sub\""
        return 1
    fi
}
test_strings.start_with

function test_strings.end_with
{
    echo "   - test_strings.end_with"
    local str="cerberus is an idea"
    local sub=" n idea"
    $strings.end_with "$str" "$sub"
    if [[ $core_strings_Ok == 1 ]];then
        echo "end_with true"
        echo "str=\"$str\""
        echo "sub=\"$sub\""
        return 1
    fi

    sub=" n idea"
    $strings.end_with "$str" "$sub"
    if [[ $end_with == 0 ]];then
        echo "end_with false"
        echo "str=\"$str\""
        echo "sub=\"$sub\""
        return 1
    fi

    sub="idea"
    $strings.end_with "$str" "$sub"
    if [[ $core_strings_Ok == 0 ]];then
        echo "end_with false"
        echo "str=\"$str\""
        echo "sub=\"$sub\""
        return 1
    fi

    sub=" idea"
    $strings.end_with "$str" "$sub"
    if [[ $core_strings_Ok == 0 ]];then
        echo "end_with false"
        echo "str=\"$str\""
        echo "sub=\"$sub\""
        return 1
    fi

    sub="  idea"
    $strings.end_with "$str" "$sub"
    if [[ $core_strings_Ok == 1 ]];then
        echo "end_with true"
        echo "str=\"$str\""
        echo "sub=\"$sub\""
        return 1
    fi
}
test_strings.end_with

function test_strings.split
{
    echo "   - test_strings.split"
    local str=",,,a,b,,cd,,ef"
    $strings.split "$str" ",,"
    if [[ ${#core_strings_Strings[@]} != 4 ]];then
        echo split str not equal 4
        return 1
    fi
    local s0=${core_strings_Strings[0]}
    local s1=${core_strings_Strings[1]} 
    local s2=${core_strings_Strings[2]} 
    local s3=${core_strings_Strings[3]} 
    if [[ "$s0" != "" || "$s1" != ",a,b" || "$s2" != "cd"  || "$s3" != "ef" ]];then
        echo split 4 not match
        echo s0="\"$s0\""
        echo s1="\"$s1\""
        echo s2="\"$s2\""
        echo s3="\"$s3\""
        return 1
    fi

    local str="a b c"
    $strings.split "$str"
    if [[ ${#core_strings_Strings[@]} != 3 ]];then
        echo split str not equal 3
        return 1
    fi
    local s0=${core_strings_Strings[0]}
    local s1=${core_strings_Strings[1]} 
    local s2=${core_strings_Strings[2]} 
    if [[ "$s0" != "a" || "$s1" != "b" || "$s2" != "c" ]];then
        echo split 4 not match
        echo s0="\"$s0\""
        echo s1="\"$s1\""
        echo s2="\"$s2\""
        return 1
    fi

}
test_strings.split

function test_strings.find_files
{
    echo "   - test_strings.find_files"
    local dir=$(cd $(dirname $BASH_SOURCE) && pwd)
    local str=`find "$dir" -maxdepth 1 -name "*.ff" -type f`
    $strings.split "$str" "
"
    if [[ ${#core_strings_Strings[@]} != 2 ]];then
        echo find files not equal 2
        return 1
    fi
    local s0=${core_strings_Strings[0]}
    local s1=${core_strings_Strings[1]}

    $strings.end_with "$s0" "/a b.ff"
    if [[ $core_strings_Ok == 0 ]];then
        echo "not found a b.ff"
        return 1
    fi
    $strings.end_with "$s1" "/c.ff"
    if [[ $core_strings_Ok == 0 ]];then
        echo "not found c.ff"
        return 1
    fi
}
test_strings.find_files

function test_strings.join
{
    echo "   - test_strings.join"
    local strs=(a b c)
    local str=`$strings.join strs ","`
    if [[ "$str" != "a,b,c" ]];then
        echo "join not equal"
        echo "strs=a,b,c"
        echo "str=$str"
        return 1
    fi
}
test_strings.join