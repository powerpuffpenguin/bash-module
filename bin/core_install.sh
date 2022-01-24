#!/usr/bin/env bash
set -e

Command="install.sh"
BaseURL="https://api.github.com/repos/powerpuffpenguin/bash_module"
DownloadName="core.tar.gz"
# TestURL="http://192.168.251.50/tools"
function mainHelp
{
    echo "install core.sh"
    echo
    echo "Usage:"
    echo "  $Command [flags]"
    echo "  $Command [command]"
    echo
    echo "Flags:"
    echo "  -t, --test          test install but won't actually install to hard disk"
    echo "  -o, --output        install dir (default \"/usr/bin\")"
    echo "  -v, --version       install version tag (default \"latest\")"
    echo "  -y, --yes           automatic yes to prompts"
    echo "  -n, --no            automatic no to prompts"
    echo "      --no-sum        don't validate archive hash"
    echo "  -h, --help          help for $Command"
}
function mainUpgradeHelp
{
    echo "upgrade core.sh"
    echo
    echo "Usage:"
    echo "  $Command [flags]"
    echo "  $Command [command]"
    echo
    echo "Flags:"
    echo "  -t, --test          test upgrade but won't actually upgrade to hard disk"
    echo "  -v, --version       upgrade version tag (default \"latest\")"
    echo "  -y, --yes           automatic yes to prompts"
    echo "  -n, --no            automatic no to prompts"
    echo "      --no-sum        don't validate archive hash"
    echo "  -h, --help          help for $Command"
}
# error
# tag_name
# assetsSize
#   * name_Index
#   * size_Index
#   * url_Index
function github._version
{
    curl -s -H "Accept: application/vnd.github.v3+json" "$1" | {
        local value
        declare -i depth=0
        local assets=0
        declare -i assetsIndex=0
        while read line
        do
            # trim
            line=$(echo $line)
            if [[ "$line" == "{" || "$line" == "[" ]];then
                depth=depth+1
                continue
            elif [[ "$line" == "}" || "$line" == "}," || "$line" == "]" || "$line" == "]," ]];then
                depth=depth-1
                if [[ $depth == 1 ]];then
                    assets=0
                elif [[ $depth == 2 ]];then
                    if [[ $assets == 1 ]];then
                        assetsIndex=assetsIndex+1
                    fi
                fi
                continue
            fi

            value=${line#\"*\":}
            key=${line::${#line}-${#value}}
            value=${value%,}
            value=$(echo $value)

            if [[ "$key" != \"*\": ]];then
                continue
            fi
            key=${key:1:${#key}-3}
            if [[ $depth == 1 ]];then
                if [[ "$key" == "message" ]];then
                    echo "local error=$value"
                    return 0
                elif [[ "$key" == "tag_name" ]];then
                    echo "local tag_name=$value"
                elif [[ "$key" == "assets" ]];then
                    assets=1 
                fi
            elif [[ $depth == 3 ]];then
                if [[ $assets == 1 ]];then
                    if [[ "$key" == "name" ]];then
                        echo "local name_$assetsIndex=$value"
                    elif [[ "$key" == "size" ]];then
                        echo "local size_$assetsIndex=$value"
                    elif [[ "$key" == "browser_download_url" ]];then
                        echo local "url_$assetsIndex=$value"
                    fi
                fi
            fi
            if [[ "$value" == "{" || "$value" == "[" ]];then
                depth=depth+1
            fi
        done
        echo "local assetsSize=$assetsIndex"
    }
}
github_Version=""
github_Download=""
github_SHA256Download=""
function github.Version
{
    local noSUM="$2"
    local url
    if [[ "$1" == "latest" ]];then
        url="$BaseURL/releases/latest"
    else
        url="$BaseURL/releases/tags/$1"
    fi
    
    echo curl -H "Accept: application/vnd.github.v3+json" "$url"
    if [[ "$TestURL" != "" ]];then
        url="$TestURL/release.json"
    fi
    # github._version "$url"
    eval $(github._version "$url")
    if [[ "$error" != "" ]];then
        echo "Error: $error"
        return 1
    elif [[ "$tag_name" == "" ]];then
        echo "Parse response tag_name error"
        return 1
    fi

    declare -i assets=$assetsSize
    local i=0
    local browser_download_url=""
    local sha256_browser_download_url=""

    for((;i<assets;i++))
    do
        eval "local name=\$name_$i"
        eval "local url=\$url_$i"
        if [[ "$name" == "$DownloadName" && "$url" != "" ]];then
            browser_download_url=$url
        elif [[ "$name" == "$DownloadName.sha256" && "$url" != "" ]];then
            sha256_browser_download_url=$url
        fi
    done

    if [[ "$browser_download_url" == "" ]];then
        echo "browser_download_url empty"
        return 1
    elif [[ $noSUM == 0  && "$sha256_browser_download_url" == "" ]];then
        echo "sha256_browser_download_url empty"
        return 1
    fi
    
    github_Version=$tag_name
    github_Download=$browser_download_url
    github_SHA256Download=$sha256_browser_download_url
    echo github_version=$tag_name
    echo browser_download_url=$browser_download_url
    if [[ "$noSUM" == 0 ]];then
        echo sha256_browser_download_url=$sha256_browser_download_url
    fi
}
compare_Error=0
declare -i compare_X=0
declare -i compare_Y=0
declare -i compare_Z=0
function compare.Parse
{
    compare_Error=0
    local str="$1."
    if (( ${#str} < 2 ));then
        compare_Error=1
        return
    fi
    str=${str:1}
    declare -i i=0
    declare -i x=0
    declare -i y=0
    declare -i z=0
    while [[ "$str" != "" ]]
    do
        local tmp=${str#*.}
        if [[ "$tmp" == "$str" ]];then
            compare_Error=1
            return
        fi
        local v=${str::${#str}-${#tmp}-1}
        declare -i n=$v
        if [[ $n != $v ]];then
            compare_Error=1
            return
        fi
        case $i in
            0)
                x=$v
                i=i+1
            ;;
            1)
                y=$v
                i=i+1
            ;;
            2)
                z=$v
                i=i+1
            ;;
            *)
                compare_Error=1
                return
            ;;
        esac
        str=$tmp
    done
    compare_X=$x
    compare_Y=$y
    compare_Z=$z
    return 0
} 

compare_Result=-1
# * 0 equal
# * 1 not matched
# * 2 local relatively new
function compare.Compare 
{
    compare.Parse "$2"
    if [[ $compare_Error == 1 ]];then
        echo "Error: parse remote version \"$2\" error"
        return 1
    elif [[ "$2" == "$1" ]];then
        compare_Result=0
        return 0
    fi
    declare -i x1=$compare_X
    declare -i y1=$compare_Y
    declare -i z1=$compare_Z

    compare.Parse "$1"
    if [[ $compare_Error == 1 ]];then
        echo "Error: parse local version \"$1\" error"
        compare_Result=1
        return 0
    fi
    declare -i x0=$compare_X
    declare -i y0=$compare_Y
    declare -i z0=$compare_Z
     if [[ $x0 == 0 && $x1 == 1 ]];then
        compare_Result=-1
        return 0
    fi

    if [[ $x0 == $x1 ]];then
        if [[ $y0 == $y1 ]];then
            if [[ $z0 == $z1 ]];then
                compare_Result=0
            elif (( $z0 < $z1 ));then
                compare_Result=-1
            else
                compare_Result=2
            fi
        elif (( $y0 < $y1 ));then
            compare_Result=-1
        else
            compare_Result=2
        fi
    elif (( $x0 < $x1 ));then
        compare_Result=1
    else
        compare_Result=2
    fi
}
function compare.Hash
{
    local str
    for str in $1
    do
        echo $str
        break
    done
}
function input.GetYes
{
    local cmd
    while read -p "$1 (y/n): " cmd
    do
        if [[ "$cmd" == "n" ]];then
            echo -n 0
            break
        elif [[ "$cmd" == "y" ]];then
            echo -n 1
            break
        fi
    done
}
function mainUpgrade
{
    ARGS=`getopt -o hto:v:y,n --long help,test,output:,version:,no-sum,yes,no -n "$Command" -- "$@"`
    eval set -- "${ARGS}"
    local version="latest"
    local output="/usr/bin"
    local test=0
    local noSUM=0
    local yesAll=0
    local noAll=0
    while true
    do
        case "$1" in
            -h|--help)
                mainUpgradeHelp
                return 0
            ;;
            -t|--test)
                test=1
                shift
            ;;
            -y|--yes)
                yesAll=1
                shift
            ;;
            -n|--no)
                noAll=1
                shift
            ;;
            --no-sum)
                noSUM=1
                shift
            ;;
            -o|--output)
                if [[ ! -d "$2" ]];then
                    echo "output dir not exists: $2"
                    return 1
                fi
                output=$(cd "$2" && pwd)
                shift 2
            ;;
            -v|--version)
                if [[ "$2" == "latest" ]];then
                    version=latest
                else
                    version="$2"
                fi
                shift 2
            ;;
            --)
                shift
                break
            ;;
            *)
                echo Error: unknown flag "$1" for "$Command"
                echo "Run '$Command --help' for usage."
                return 1
            ;;
        esac
    done

    # get version
    github.Version "$version" "$noSUM"
}
function mainInstall
{
    ARGS=`getopt -o hto:v:y,n --long help,test,output:,version:,no-sum,yes,no -n "$Command" -- "$@"`
    eval set -- "${ARGS}"
    local version="latest"
    local output="/usr/bin"
    local test=0
    local noSUM=0
    local yesAll=0
    local noAll=0
    while true
    do
        case "$1" in
            -h|--help)
                mainHelp
                return 0
            ;;
            -t|--test)
                test=1
                shift
            ;;
            -y|--yes)
                yesAll=1
                shift
            ;;
            -n|--no)
                noAll=1
                shift
            ;;
            --no-sum)
                noSUM=1
                shift
            ;;
            -o|--output)
                if [[ ! -d "$2" ]];then
                    echo "output dir not exists: $2"
                    return 1
                fi
                output=$(cd "$2" && pwd)
                shift 2
            ;;
            -v|--version)
                if [[ "$2" == "latest" ]];then
                    version=latest
                else
                    version="$2"
                fi
                shift 2
            ;;
            --)
                shift
                break
            ;;
            *)
                echo Error: unknown flag "$1" for "$Command"
                echo "Run '$Command --help' for usage."
                return 1
            ;;
        esac
    done

    # get version
    github.Version "$version" "$noSUM"

    local success="successfully installed to \"$output\". $github_Version"
    # compare version
    if [[ -f "$output/core.sh" ]];then
        local version=$({
            source $output/core.sh
            echo $core_Version
        })
        compare.Compare "$version" "$github_Version"
        case $compare_Result in
            0)
                echo "An identical version already exists: $version"
                if [[ $noAll == 1 ]];then
                    echo automatic canceled
                    return 1
                elif [[ $yesAll == 0 ]];then
                    local ok=$(input.GetYes "do you want to reinstall?")
                    if [[ "$ok" == 0 ]];then
                        echo user canceled
                        return      
                    fi
                fi
                success="successfully reinstall to \"$output\". $github_Version"
            ;;
            1)
                echo "A mismatched version is already installed, do you want to force an upgrade?"
                echo "upgrade: $version -> $github_Version"
                if [[ $noAll == 1 ]];then
                    echo automatic canceled
                    return 1
                elif [[ $yesAll == 0 ]];then
                    local ok=$(input.GetYes "do you want to upgrade?")
                    if [[ "$ok" == 0 ]];then
                        echo user canceled
                        return      
                    fi
                fi
                success="successfully upgraded to \"$output\". $version -> $github_Version"
            ;;
            2)
                echo "A newer version is installed locally, do you want to force downgrade to the older version?"
                echo "downgrade: $version -> $github_Version"
                if [[ $noAll == 1 ]];then
                    echo automatic canceled
                    return 1
                elif [[ $yesAll == 0 ]];then
                    local ok=$(input.GetYes "do you want to upgrade?")
                    if [[ "$ok" == 0 ]];then
                        echo user canceled
                        return      
                    fi
                fi
                success="successfully downgrade to \"$output\". $version -> $github_Version"
            ;;
            *)
                success="successfully upgraded to \"$output\". $version -> $github_Version"
            ;;
        esac
    fi
    # get hash
    if [[ $noSUM == 0 ]];then
        local url=$github_SHA256Download
        echo curl -sL "$url"
        if [[ "$TestURL" != "" ]];then
            url="$TestURL/release.sha512"
        fi
        local hash="$(curl -sL "$url")"
        hash=$(compare.Hash "$hash")
    fi

    # download
    local url=$github_Download
    echo curl -#Lo "$DownloadName" "$url"
    curl -#Lo "$DownloadName" "$url"

    # check hash
    if [[ "$hash" != "" ]];then
        echo check sum
        local str=$(sha256sum "$DownloadName")
        str=$(compare.Hash "$str")
        if [[ "$str" != "$hash" ]];then
            echo sha256sum not match
            echo remote "$hash"
            echo download "$str"
            return 1
        fi
    fi
    echo tar -zxvf "$DownloadName" -C "$output"
    if [[ $test == 0 ]];then
        tar -zxvf "$DownloadName" -C "$output"
    fi
    rm "$DownloadName"
    echo $success
}
function mainRemoveHelp
{
     echo "remove core.sh"
    echo
    echo "Usage:"
    echo "  $Command [flags]"
    echo "  $Command [command]"
    echo
    echo "Flags:"
    echo "  -t, --test          test remove but won't actually remove from hard disk"
    echo "  -h, --help          help for $Command"
}
function mainRemove
{
    local test=0
    ARGS=`getopt -oth --long help,test -n "$Command" -- "$@"`
    eval set -- "${ARGS}"
    while true
    do
        case "$1" in
            -h|--help)
                mainRemoveHelp
                return 0
            ;;
            -t|--test)
                test=1
                shift
            ;;
            --)
                shift
                break
            ;;
            *)
                echo Error: unknown flag "$1" for "$Command"
                echo "Run '$Command --help' for usage."
                return 1
            ;;
        esac
    done
    local dir=$(cd $(dirname $BASH_SOURCE) && pwd)
    local files=(
        core.sh
        core.libs/colors.sh
        core.libs/strings.sh
        core.libs
        abc
    )
    local file
    for file in "${files[@]}"
    do
        file="$dir/$file"
        if [[ "$file" == *.sh ]];then
            if [[ -f "$file" ]];then
                echo rm "$file"
                if [[ $test == 0 ]];then
                    rm "$file"
                fi
            fi
        elif [[ -d "$file" ]];then
            if [[ "$(find "$file")" == "$file" ]];then
                echo rmdir $file
                 if [[ $test == 0 ]];then
                    rmdir "$file"
                fi
            fi
        fi
    done
}
function displayHelp
{
    Command="core_install.sh"
    echo "install core.sh"
    echo
    echo "Usage:"
    echo "  $Command [flags]"
    echo "  $Command [command]"
    echo
    echo "Available Commands:"
    echo "  install           install core.sh"
    echo "  upgrade           upgrade core.sh"
    echo "  remove            remove  core.sh"
    echo "  help              help for $Command"
    echo
    echo "Flags:"
    echo "  -h, --help          help for $Command"
}

case "$1" in
    -h|--help)
        displayHelp
        exit 0
    ;;
    remove)
        shift 1
        Command="core_install.sh remove"
        mainRemove "$@"
        exit $?
    ;;
    install)
        shift 1
        Command="core_install.sh install"
        mainInstall "$@"
        exit $?
    ;;
    upgrade)
        shift 1
        Command="core_install.sh upgrade"
        mainUpgrade "$@"
        exit $?
    ;;
esac
displayHelp
exit 1