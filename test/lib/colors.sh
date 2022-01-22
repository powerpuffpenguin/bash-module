#!/usr/bin/env bash
set -e
echo " * $BASH_SOURCE"
source core.sh

Import "core:colors.sh"
colors="core_colors"

function test_colors
{
    local funcs=(
        white black 
        dark_gray light_gray
        red green yellow blue magenta cyan
        light_red  light_green light_yellow light_blue light_magenta light_cyan
    )
    local f
    for f in ${funcs[@]}
    do
        echo -n "   - "
        $colors.$f
        echo -n "$f color: '$f'"
        $colors.default

        $colors.$f 1
        echo -n " background: '$f'"
        $colors.default 1
        echo
    done
}
test_colors