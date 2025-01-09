#!/bin/sh

result=$(osascript -e '
set userName to short user name of (system info)

do shell script "echo " & quoted form of userName
')

echo "$result"

sketchybar --set "$NAME" label="$result" icon.drawing=off
