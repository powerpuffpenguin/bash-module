#!/usr/bin/env bash

set -e

Dir=$(cd $(dirname $BASH_SOURCE) && pwd)
export PATH="$Dir/core:$PATH"

dirs=(
    "test"
    "test/lib"
)

for dir in ${dirs[@]} 
do
    find "$Dir/$dir" -maxdepth 1 -name "*_test.sh" -type f | 
    while read file
    do
        "$file"
    done
done

"$Dir/test/lib/colors.sh"