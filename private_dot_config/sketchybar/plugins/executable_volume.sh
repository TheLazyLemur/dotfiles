#!/bin/sh

# The volume_change event supplies a $INFO variable with the current volume percentage.

if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"

  case "$VOLUME" in
    [6-9][0-9]|100) ICON="󰕾 " COLOR="0xffcba6f7" ;;  # Bright purple for high volume
    [3-5][0-9]) ICON="󰖀" COLOR="0xff89b4fa" ;;       # Soft blue for medium volume
    [1-9]|[1-2][0-9]) ICON="󰕿" COLOR="0xffa6adc8" ;; # Muted gray-blue for low volume
    *) ICON="󰖁" COLOR="0xff7f849c" ;;                # Dimmed purple for mute
  esac

  sketchybar --set "$NAME" icon="$ICON" label="$VOLUME%" \
        icon.font="ComicShannsMono Nerd Font:Bold:18" \
        icon.color="$COLOR" background.border_color="$COLOR"
fi
