#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

if [ "$1" = "$(aerospace list-workspaces --focused)" ]; then
    sketchybar --set $NAME background.drawing=on \
        label.font="ComicShannsMono Nerd Font:Bold:22" \
        label.color=0xffcdd6f4 \
        icon.font="ComicShannsMono Nerd Font:Bold:22" \
        label.color=0xffe0def4 \
        icon.color=0xffe0def4 \
        background.border_color=0xffe0def4 \
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
