#!/usr/bin/env bash
# document https://github.com/powerpuffpenguin/bash_module/blob/main/document/colors.md
if [[ "$__module_flag_of_core_colors" == 1 ]];then
    return 0
fi
__module_flag_of_core_colors=1

# func Black(background:any=0)
function core_colors.Black
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[30m"
    else
        echo -en "\e[40m"
    fi
}
# func Red(background:any=0)
function core_colors.Red
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[31m"
    else
        echo -en "\e[41m"
    fi
}
# func Green(background:any=0)
function core_colors.Green
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[32m"
    else
        echo -en "\e[42m"
    fi
}
# func Yellow(background:any=0)
function core_colors.Yellow
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[33m"
    else
        echo -en "\e[43m"
    fi
}
# func Blue(background:any=0)
function core_colors.Blue
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[34m"
    else
        echo -en "\e[44m"
    fi
}
# func Magenta(background:any=0)
function core_colors.Magenta
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[35m"
    else
        echo -en "\e[45m"
    fi
}
# func Cyan(background:any=0)
function core_colors.Cyan
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[36m"
    else
        echo -en "\e[46m"
    fi
}
# func LightGray(background:any=0)
function core_colors.LightGray
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[37m"
    else
        echo -en "\e[47m"
    fi
}

# func DarkGray(background:any=0)
function core_colors.DarkGray
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[90m"
    else
        echo -en "\e[100m"
    fi
}
# func LightRed(background:any=0)
function core_colors.LightRed
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[91m"
    else
        echo -en "\e[101m"
    fi
}
# func LightGreen(background:any=0)
function core_colors.LightGreen
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[92m"
    else
        echo -en "\e[102m"
    fi
}
# func LightYellow(background:any=0)
function core_colors.LightYellow
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[93m"
    else
        echo -en "\e[103m"
    fi
}
# func LightBlue(background:any=0)
function core_colors.LightBlue
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[94m"
    else
        echo -en "\e[104m"
    fi
}
# func LightMagenta(background:any=0)
function core_colors.LightMagenta
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[95m"
    else
        echo -en "\e[105m"
    fi
}
# func LightCyan(background:any=0)
function core_colors.LightCyan
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[96m"
    else
        echo -en "\e[106m"
    fi
}
# func White(background:any=0)
function core_colors.White
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[97m"
    else
        echo -en "\e[107m"
    fi
}
# func Default(background:any=0)
function core_colors.Default
{
    if [[ "$1" == "" || "$1" == "0" ]];then
        echo -en "\e[39m"
    else
        echo -en "\e[49m"
    fi
}
# func Reset()
function core_colors.Reset
{
    echo -en "\e[0m"
}