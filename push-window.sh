#!/usr/bin/env bash
# Push focused window to the other workspace (1↔2) — aismokeshow

current=$(aerospace list-workspaces --focused 2>/dev/null)
[ -z "$current" ] && exit 1

if [ "$current" = "1" ]; then
    aerospace move-node-to-workspace 2
elif [ "$current" = "2" ]; then
    aerospace move-node-to-workspace 1
fi
