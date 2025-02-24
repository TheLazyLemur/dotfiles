#!/bin/sh

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

case "${PERCENTAGE}" in
  9[0-9]|100) ICON="" COLOR="0xff89b4fa" ;;  # Bright blue for high charge
  [6-8][0-9]) ICON="" COLOR="0xff89b4fa" ;;
  [3-5][0-9]) ICON="" COLOR="0xfff9e2af" ;;  # Warm orange for medium charge
  [1-2][0-9]) ICON="" COLOR="0xfff38ba8" ;;  # Alert red for low charge
  *) ICON="" COLOR="0xfff38ba8" ;;
esac

if [[ "$CHARGING" != "" ]]; then
  ICON="" COLOR="0xff89b4fa"  # Electric blue when charging
fi

# Update the SketchyBar item with the new values
sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="$PERCENTAGE%" background.border_color="$COLOR"
