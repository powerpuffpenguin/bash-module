#!/usr/bin/env bash

set -e

Dir=$(cd $(dirname $BASH_SOURCE) && pwd)
cd $Dir
source core/core.sh
find test -name "*_test.sh" -type f | 
while read file
do
    "$Dir/$file"
done