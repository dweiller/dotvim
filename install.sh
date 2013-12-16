#!/bin/bash

cd ~/.vim

#create symlinks
ln -s vimrc ~/.vimrc

#Grab the submodules
git submodule init
git submodule update
