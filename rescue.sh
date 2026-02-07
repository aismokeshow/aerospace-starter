#!/usr/bin/env bash
# rescue.sh — Re-tile all windows on the current workspace
#
# AeroSpace can lose track of floating windows, sending them off-screen
# to the bottom-right corner where they're invisible but still "on" the
# workspace. This script forces every window on the focused workspace
# back into the tiling layout.
#
# Bind it in aerospace.toml:
#   alt-shift-r = 'exec-and-forget ~/.config/aerospace/rescue.sh'
#
# aismokeshow // aismokeshow.com

set -euo pipefail

AEROSPACE="/opt/homebrew/bin/aerospace"

# Fallback for Intel Macs
if [[ ! -x "$AEROSPACE" ]]; then
    AEROSPACE=$(command -v aerospace 2>/dev/null || echo "")
    if [[ -z "$AEROSPACE" ]]; then
        echo "aerospace not found" >&2
        exit 1
    fi
fi

current_ws=$($AEROSPACE list-workspaces --focused)
rescued=0

while IFS='|' read -r wid _rest; do
    wid=$(echo "$wid" | tr -d ' ')
    [ -z "$wid" ] && continue
    $AEROSPACE layout --window-id "$wid" tiling 2>/dev/null && rescued=$((rescued + 1))
done < <($AEROSPACE list-windows --workspace "$current_ws" --format '%{window-id}|%{app-name}')

$AEROSPACE balance-sizes 2>/dev/null || true

if [[ "$rescued" -gt 0 ]]; then
    osascript -e "display notification \"Re-tiled $rescued window(s)\" with title \"AeroSpace\"" 2>/dev/null &
fi
