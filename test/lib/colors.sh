#!/usr/bin/env bash
set -e
echo " * $BASH_SOURCE"
source core.sh

core.Import "core:colors.sh"
colors="core_colors"

function test_colors
{
    local funcs=(
        White Black 
        DarkGray LightGray
        Red Green Yellow Blue Magenta Cyan
        LightRed  LightGreen LightYellow LightBlue LightMagenta LightCyan
    )
    local f
    for f in ${funcs[@]}
    do
        echo -n "   - "
        $colors.$f
        echo -n "$f color: '$f'"
        $colors.Default

        $colors.$f 1
        echo -n " background: '$f'"
        $colors.Default 1
        echo
    done
}
test_colors