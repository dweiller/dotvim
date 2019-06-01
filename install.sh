#!/bin/bash

#create symlinks
ln -s ~/.vim/vimrc ~/.vimrc || fail=true
if [ $fail ] ; then
	echo "Found previous $HOME/.vimrc configuration file - exiting installation. Remove/backup your .vimrc file and try to reinstall"
	exit 1
fi
