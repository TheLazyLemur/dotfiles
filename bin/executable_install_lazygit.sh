#!/usr/bin/env bash

set -e

if ! command -v brew &>/dev/null; then
    echo "Error: Homebrew is not installed. Install it first."
    exit 1
fi

brew install go

LAZYGIT_DIR="$HOME/src/lazygit"
INSTALL_DIR="$HOME/local/lazygit/lazygit"
SHELL_CONFIG="$HOME/.zshrc"

mkdir -p $HOME/src

rm -rf $LAZYGIT_DIR
git clone https://github.com/jesseduffield/lazygit.git $LAZYGIT_DIR

cd $LAZYGIT_DIR

go build -o $INSTALL_DIR

if ! grep -Fxq "export PATH=\$PATH:\$HOME/local/lazygit/lazygit" "$SHELL_CONFIG"; then
    echo "export PATH=\$PATH:\$HOME/local/lazygit/lazygit" >> "$SHELL_CONFIG"
    echo "Added Lazygit to PATH in $SHELL_CONFIG"
else
    echo "Lazygit is already in PATH"
fi

