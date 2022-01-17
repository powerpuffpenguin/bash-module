#!/usr/bin/env bash
set -e
source core/core.sh

function test_import
{
    Import "core/a.sh"
    local a="a"
    local b="a_b"

    if [[ "`$a.echo`" != "this is a" ]];then
        echo a.echo not equal
    fi

    if [[ "`$b.echo`" != "this is b" ]];then
        echo a.b.echo not equal
    fi
}
test_import

function test_zoo
{
    # import
    Import "core/zoo.sh"
    local zoo="core_zoo"
    local Cat="core_zoo_Cat"

    # s0 = new Cat
    $Cat.new "ka te" 1
    eval `$Cat.get "local s0"`

    # s1 = new Cat
    $Cat.new anita 99
    eval `$Cat.get "local s1"`

    # s0.speak
    eval `$Cat.set s0`
    $Cat.speak

    # s1.speak
    eval `$Cat.set s1`
    $Cat.speak
}
test_zoo