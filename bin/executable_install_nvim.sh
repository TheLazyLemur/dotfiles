#!/usr/bin/env bash

set -e

if ! command -v brew &>/dev/null; then
    echo "Error: Homebrew is not installed. Install it first."
    exit 1
fi

brew install ninja cmake gettext curl

# Define paths
NEOVIM_DIR="$HOME/src/neovim"
INSTALL_DIR="$HOME/local/nvim"
SHELL_CONFIG="$HOME/.zshrc"

mkdir -p "$HOME/src"

rm -rf "$NEOVIM_DIR"
git clone https://github.com/neovim/neovim.git "$NEOVIM_DIR"

cd "$NEOVIM_DIR"
make CMAKE_INSTALL_PREFIX="$INSTALL_DIR" install

if ! grep -Fxq "export PATH=\$INSTALL_DIR/bin:\$PATH" "$SHELL_CONFIG"; then
    echo "export PATH=$INSTALL_DIR/bin:\$PATH" >> "$SHELL_CONFIG"
    echo "Added Neovim to PATH in $SHELL_CONFIG"
else
    echo "Neovim is already in PATH"
fi
