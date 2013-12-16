#!/bin/bash

#create symlinks
ln -s ~/.vim/vimrc ~/.vimrc

#Grab the submodules
cd ~/.vim
git submodule update --init
