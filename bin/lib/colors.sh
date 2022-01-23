#!/usr/bin/env bash
# document https://github.com/powerpuffpenguin/bash_module/blob/main/document/colors.md
if [[ "$__module_flag_of_core_colors" == 1 ]];then
    return 0
fi
__module_flag_of_core_colors=1

# func black(background:any=0)
function core_colors.black
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[30m"
    else
        echo -en "\e[40m"
    fi
}
# func red(background:any=0)
function core_colors.red
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[31m"
    else
        echo -en "\e[41m"
    fi
}
# func green(background:any=0)
function core_colors.green
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[32m"
    else
        echo -en "\e[42m"
    fi
}
# func yellow(background:any=0)
function core_colors.yellow
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[33m"
    else
        echo -en "\e[43m"
    fi
}
# func blue(background:any=0)
function core_colors.blue
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[34m"
    else
        echo -en "\e[44m"
    fi
}
# func magenta(background:any=0)
function core_colors.magenta
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[35m"
    else
        echo -en "\e[45m"
    fi
}
# func cyan(background:any=0)
function core_colors.cyan
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[36m"
    else
        echo -en "\e[46m"
    fi
}
# func light_gray(background:any=0)
function core_colors.light_gray
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[37m"
    else
        echo -en "\e[47m"
    fi
}

# func dark_gray(background:any=0)
function core_colors.dark_gray
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[90m"
    else
        echo -en "\e[100m"
    fi
}
# func light_red(background:any=0)
function core_colors.light_red
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[91m"
    else
        echo -en "\e[101m"
    fi
}
# func light_green(background:any=0)
function core_colors.light_green
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[92m"
    else
        echo -en "\e[102m"
    fi
}
# func light_yellow(background:any=0)
function core_colors.light_yellow
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[93m"
    else
        echo -en "\e[103m"
    fi
}
# func light_blue(background:any=0)
function core_colors.light_blue
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[94m"
    else
        echo -en "\e[104m"
    fi
}
# func light_magenta(background:any=0)
function core_colors.light_magenta
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[95m"
    else
        echo -en "\e[105m"
    fi
}
# func light_cyan(background:any=0)
function core_colors.light_cyan
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[96m"
    else
        echo -en "\e[106m"
    fi
}
# func white(background:any=0)
function core_colors.white
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[97m"
    else
        echo -en "\e[107m"
    fi
}
# func default(background:any=0)
function core_colors.default
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[39m"
    else
        echo -en "\e[49m"
    fi
}
# func reset()
function core_colors.reset
{
    echo -en "\e[0m"
}