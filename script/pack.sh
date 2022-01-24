#!/usr/bin/env bash
set -e

BashDir=$(cd "$(dirname $BASH_SOURCE)" && pwd)
source "$BashDir/conf.sh"
if [[ "$Command" == "" ]];then
    Command="$0"
fi

function help(){
    echo "pack release"
    echo
    echo "Usage:"
    echo "  $Command [flags]"
    echo
    echo "Flags:"
    echo "  -p, --pack          pack to compressed package (default \"gz\") [7z gz bz2 xz zip]"
    echo "  -h, --help          help for $Command"
}

ARGS=`getopt -o hp: --long help,pack: -n "$Command" -- "$@"`
eval set -- "${ARGS}"
pack="gz"
while true
do
    case "$1" in
        -h|--help)
            help
            exit 0
        ;;
        -p|--pack)
            case "$2" in
                7z|gz|bz2|xz|zip)
                    pack="$2"
                ;;
                *)
                    echo Error: unknown pack "$2" for "$Command --pack"
                    echo "Supported: 7z gz bz2 xz zip"
                    exit 1
                ;;
            esac
            shift 2
        ;;
        --)
            shift
            break
        ;;
        *)
            echo Error: unknown flag "$1" for "$Command"
            echo "Run '$Command --help' for usage."
            exit 1
        ;;
    esac
done

name="core"
case "$pack" in
    7z)
        name="$name.7z"
        args=(7z a "$name")
    ;;
    zip)
        name="$name.zip"
        args=(zip -r "$name")
    ;;
    gz)
        name="$name.tar.gz"
        args=(tar -zcvf "$name")
    ;;
    bz2)
        name="$name.tar.bz2"
        args=(tar -jcvf "$name")
    ;;
    xz)
        name="$name.tar.xz"
        args=(tar -Jcvf "$name")
    ;;
    *)
        echo "unknow pack: $pack"
        exit 0
    ;;
esac
cd "$Dir/bin"
if [[ -f "$name" ]];then
    rm "$name"
fi
source=(
    core.sh core.libs 
    core_install.sh
)

exec="${args[@]} ${source[@]}"
echo $exec
eval "$exec"

exec="sha256sum $name > $name.sha256"
echo $exec
eval "$exec"