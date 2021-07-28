#!/usr/bin/env bash
set -euo pipefail

open -a /Applications/Emacs.app

if [ -f "/usr/local/bin/pfind" ]; then
    ypid=$(/usr/local/bin/pfind yabai)
else
    ypid=$(ps -x | grep yabai | grep -v grep | awk '{print $1}')
fi

if [ "$ypid" != "" ]; then
    /usr/local/bin/yabai -m space --focus 2
fi

unset ypid
