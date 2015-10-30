#!/bin/bash
#This script is currently untested
mode=$1
shift

for i in "$@"
do
    case $i in
        --install=*)
            url="${i#*=}"
            bundle=${url##*/}
            bundle=${bundle%.vim}
            shift
            ;;
        *)
            echo "Error, unkown option."
            exit 1
            ;;
    esac
done

if [ $mode=="bundle" ]
    then
        if [ "$PWD" != "$HOME/.vim" ]
            then
                cd ~/.vim
        fi
        git submodule add ${url} bundle/${bundle}
fi
