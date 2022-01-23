#!/usr/bin/env bash

set -e

BashDir=$(cd "$(dirname $BASH_SOURCE)" && pwd)
export PATH="$BashDir/bin:$PATH"
if [[ "$Command" == "" ]];then
    Command="$0"
fi

function help(){
    echo "build script"
    echo
    echo "Usage:"
    echo "  $0 [flags]"
    echo "  $0 [command]"
    echo
    echo "Available Commands:"
    echo "  help              help for $0"
    echo "  pack              pack release"
    echo "  color             run color"
    echo "  test              run test"
    echo
    echo "Flags:"
    echo "  -h, --help          help for $0"
}

case "$1" in
    help|-h|--help)
        help
    ;;
    pack)
        shift
        export Command="$0 pack"
        "$BashDir/script/pack.sh" "$@"
    ;;
    color)
        shift
        export Command="$0 color"
        "$BashDir/script/color.sh" "$@"
    ;;
    test)
        shift
        export Command="$0 test"
        "$BashDir/script/test.sh" "$@"
    ;;
    *)
        if [[ "$1" == "" ]];then
            help
        elif [[ "$1" == -* ]];then
            echo Error: unknown flag "$1" for "$0"
            echo "Run '$0 --help' for usage."
        else
            echo Error: unknown command "$1" for "$0"
            echo "Run '$0 --help' for usage."
        fi        
        exit 1
    ;;
esac