#!/usr/bin/env bash
set -euo pipefail

if [ -f "/usr/local/bin/pfind" ]; then
    kpid=$(/usr/local/bin/pfind kitty)
    ypid=$(/usr/local/bin/pfind yabai)
else
    kpid=$(ps -x | grep kitty | grep -v grep | grep -v kitty.sh | awk '{print $1}')
    ypid=$(ps -x | grep yabai | grep -v grep | awk '{print $1}')
fi

if [ "$kpid" = "" ]; then
    open -a "/Applications/kitty.app"
else
    /usr/local/bin/kitty @ --to unix:/tmp/kitty-"$kpid" launch --type=os-window
fi


if [ "$ypid" != "" ]; then
    /usr/local/bin/yabai -m space --focus 1
fi

unset ypid
unset kpid
