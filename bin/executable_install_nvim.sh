#!/usr/bin/env bash

brew install ninja cmake gettext curl

mkdir -p $HOME/src

rm -rf $HOME/src/neovim
git clone https://github.com/neovim/neovim.git $HOME/src/neovim

cd $HOME/src/neovim

make CMAKE_INSTALL_PREFIX=$HOME/local/nvim install

if ! grep -Fxq "export PATH=\$HOME/local/nvim/bin:\$PATH" ~/.zshrc; then
    echo "export PATH=\$HOME/local/nvim/bin:\$PATH" >> ~/.zshrc
    echo "Line added to .zshrc"
else
    echo "Line already exists in .zshrc"
fi
