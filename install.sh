#!/bin/bash

#create symlinks
ln -s ~/.vim/vimrc ~/.vimrc || fail=true
if [ $fail ] ; then
	echo "Found previous $HOME/.vim configuration file - exiting installation. Backup your .vim file (to another location) and try to reinstall"
	exit 1
fi

#Grab the submodules
cd ~
ln -s .vim/vimrc .vimrc
cd ~/.vim
git submodule update --init
