#!/bin/bash
mode=$1
shift

for i in "$@"
do
    case $i in
        --install=*)
            url=${i##*=}
            bundle=${url##*/}
            bundle=${bundle%.git}
            shift
            ;;
        *)
            echo "Error, unkown option."
            exit 1
            ;;
    esac
done

if [ "$mode" = "bundle" ]
    then
        if [ "$PWD" != "$HOME/.vim" ]
            then
                cd ~/.vim
        fi
        git submodule add ${url} bundle/${bundle}
fi
