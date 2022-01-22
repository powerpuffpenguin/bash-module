#!/usr/bin/env bash

set -e

Dir=$(cd $(dirname $BASH_SOURCE) && pwd)

if [[ "$1" == "" ]];then
    echo -e "\e[31mplease input install dir\e[0m"
    exit 1
fi
if [ ! -d "$1" ];then
    echo -e "\e[31moutput not exists: \"$1\"\e[0m"
    exit 1
fi

Output=$(cd "$1" && pwd)

echo cp "core/core.sh" "$Output/core.sh"
cp "$Dir/core/core.sh" "$Output/core.sh"
echo cp "core/lib" "$Output" -r
cp "$Dir/core/lib" "$Output" -r

echo -e "\e[32minstall success\e[0m"