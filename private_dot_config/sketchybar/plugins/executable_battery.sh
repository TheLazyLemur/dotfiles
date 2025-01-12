#!/bin/sh

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

case "${PERCENTAGE}" in
  9[0-9]|100) ICON="" COLOR="0xff3e8fb0"
  ;;
  [6-8][0-9]) ICON="" COLOR="0xff3e8fb0"
  ;;
  [3-5][0-9]) ICON="" COLOR="0xffd7827e"
  ;;
  [1-2][0-9]) ICON="" COLOR="0xffeb6f92"
  ;;
  *) ICON=""
esac

if [[ "$CHARGING" != "" ]]; then
  ICON="" COLOR="0xff3e8fb0"
fi

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="$PERCENTAGE%" background.border_color="$COLOR"
