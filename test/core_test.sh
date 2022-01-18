#!/usr/bin/env bash
set -e
echo " * $BASH_SOURCE"
source core.sh

function test_import
{
    echo "   - test_import"
    Import "core/a.sh"
    local a="a"
    local b="a_b"

    if [[ "`$a.echo`" != "this is a" ]];then
        echo a.echo not equal
        return 1
    fi

    if [[ "`$b.echo`" != "this is b" ]];then
        echo a.b.echo not equal
        return 1
    fi
}
test_import

function test_copy
{
    echo "   - test_copy"
    local a=(
        "abc"
        "def"
    )
    local b
    Copy b a
    if [[ ${#a} != ${#b} ]];then
        echo' len(a) != len(b)'
        return 1
    fi
    local i
    for((i=0;i<${#a};i++))
    do
        if [[ "${a[i]}" != "${b[i]}" ]];then
            echo "a[$i] != b[$i]"
            echo "a[$i]=${a[i]}"
            echo "b[$i]=${b[i]}"
            return 1
        fi
    done
}
test_copy

function test_zoo
{
    echo "   - test_zoo"
    # import
    Import "core/zoo.sh"
    local zoo="core_zoo"
    local Cat="core_zoo_Cat"

    # s0 = new Cat
    local s0
    $Cat.new "ka te" 1
    Copy s0 $Cat

    # s1 = new Cat
    local s1
    $Cat.new anita 99
    Copy s1 $Cat

    # s0.speak
    if [[ `$Cat.speak s0` != "i'm ka te, a cat. my level is 1." ]];then
        echo '$Cat.speak s0 not match'
        return 1
    fi

    # s1.speak
    if [[ `$Cat.speak s1` != "i'm anita, a cat. my level is 99." ]];then
        echo '$Cat.speak s1 not match'
        return 1
    fi

    # clone
    local a
    Copy a s0
    local name=`$Cat.name a`
    if [[ $name != "ka te" ]];then
        echo '$Cat.name get not match'
        return 1
    fi
    $Cat.name a "ab cd"

    local level=`$Cat.level a`
    if [[ $level != 1 ]];then
        echo '$Cat.level get not match'
        return 1
    fi
    $Cat.level a 22

    if [[ `$Cat.speak a` != "i'm ab cd, a cat. my level is 22." ]];then
        echo '$Cat.speak s1 not match'
        return 1
    fi
}
test_zoo