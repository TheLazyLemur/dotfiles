# Dotfiles

## Overview
This is setup using [chezmoi](https://www.chezmoi.io/).

## Usage

```bash
chezmoi init https://github.com/TheLazyLemur/dotfiles.git
chezmoi apply
```

### For MacOS users who want to use hammerspoon

Hammerspoon expects its config to be in `~/.hammerspoon` and not `~/.config/hammerspoon`.
To fix this, run the following command:
```bash
ln -s /Users/<USER_DIR>/.config/hammerspoon /Users/<USER_DIR>/.hammerspoon
```
