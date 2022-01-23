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

# func (self Cat)speak()
function core_zoo_Cat.speak
{
    if [[ "$1" == "" ]];then
        Error "Error: call ${FUNCNAME[0]} missing self"
        ErrorStack 1
        return 1
    fi
    local self
    core.copy self "$1"
    echo -n "i'm ${self[core_zoo_Cat_name]}, a cat."
    echo " my level is ${self[core_zoo_Cat_level]}."
}
# func (self Cat)name(): string
# func (self Cat)name(val: string)
function core_zoo_Cat.name
{
    
    case ${#@} in
        0)
            core.error "Error: call ${FUNCNAME[0]} missing self"
            core.error_stack 1
            return 1
        ;;
        1) # get
            core.field "$1" $core_zoo_Cat_name 
        ;;
        *) # set
            core.field "$1" $core_zoo_Cat_name "$2"
        ;;
    esac
}
# func (self Cat)level(): number
# func (self Cat)level(val: number)
function core_zoo_Cat.level
{
    
    case ${#@} in
        0)
            core.error "Error: call ${FUNCNAME[0]} missing self"
            core.error_stack 1
            return 1
        ;;
        1) # get
            core.field "$1" $core_zoo_Cat_level
        ;;
        *) # set
            core.field "$1" $core_zoo_Cat_level "$2"
        ;;
    esac
}
