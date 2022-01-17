#!/usr/bin/env bash


# define new class named Cat
core_zoo_Cat=()
core_zoo_Cat_name=0
core_zoo_Cat_level=1

# new Cat(name: string,level: number)
function core_zoo_Cat.new
{
    core_zoo_Cat[core_zoo_Cat_name]="$1"
    core_zoo_Cat[core_zoo_Cat_level]="$2"
}
# get and set
eval "`Class core_zoo_Cat`"

function core_zoo_Cat.speak
{
    echo -n "i'm ${core_zoo_Cat[core_zoo_Cat_name]}, a cat."
    echo " my level is ${core_zoo_Cat[core_zoo_Cat_level]}."
}

