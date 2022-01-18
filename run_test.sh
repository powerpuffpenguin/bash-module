#!/usr/bin/env bash

# set -e

Dir=$(cd $(dirname $BASH_SOURCE) && pwd)
export PATH="$Dir/core:$PATH"

find "$Dir/test" -name "*_test.sh" -type f | 
while read file
do
    "$file"
done