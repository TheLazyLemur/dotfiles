#!/usr/bin/env bash

# Make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

if [ "$1" = "$(aerospace list-workspaces --focused)" ]; then
    sketchybar --set $NAME background.drawing=on \
        label.font="ComicShannsMono Nerd Font:Bold:22" \
        icon.font="ComicShannsMono Nerd Font:Bold:22" \
        label.color=0xff89b4fa \
        icon.color=0xff89b4fa \
        background.border_color=0xff89b4fa \
        icon=" "
else
    sketchybar --set $NAME background.drawing=off \
        label.font="ComicShannsMono Nerd Font:Bold:18" \
        label.color=0xff45475a \
        icon.font="ComicShannsMono Nerd Font:Bold:18" \
        icon.color=0xff45475a \
        icon=" "
fi
