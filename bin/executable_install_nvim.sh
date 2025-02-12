#!/usr/bin/env bash

mkdir -p $HOME/src
sudo rm -rf $HOME/src/neovim
git clone https://github.com/neovim/neovim.git $HOME/src/neovim

brew install ninja cmake gettext curl

cd $HOME/src/neovim

sudo make install
