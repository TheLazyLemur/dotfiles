#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

if [ "$1" = "$(aerospace list-workspaces --focused)" ]; then
    sketchybar --set $NAME background.drawing=on \
        label.font="ComicShannsMono Nerd Font:Bold:22" \
        label.color=0xffcdd6f4 \
        icon.font="ComicShannsMono Nerd Font:Bold:22" \
        label.color=0xffd7827e \
        icon.color=0xffd7827e \
        icon=" "
else
    sketchybar --set $NAME background.drawing=off \
        label.font="ComicShannsMono Nerd Font:Bold:18" \
        label.color=0x55cdd6f4 \
        icon.font="ComicShannsMono Nerd Font:Bold:18" \
        label.color=0xffcdd6f4 \
        icon.color=0xffcdd6f4 \
        icon=" "
fi
