#!/usr/bin/env bash
# toggle.sh — Toggle between workspace 1 and 2
# aismokeshow // aismokeshow.com

set -euo pipefail

# Find aerospace binary — check both Homebrew paths, then fall back to PATH
if [[ -x "/opt/homebrew/bin/aerospace" ]]; then
    AEROSPACE="/opt/homebrew/bin/aerospace"
elif [[ -x "/usr/local/bin/aerospace" ]]; then
    AEROSPACE="/usr/local/bin/aerospace"
else
    AEROSPACE=$(command -v aerospace 2>/dev/null || echo "")
    if [[ -z "$AEROSPACE" ]]; then
        echo "aerospace not found" >&2
        exit 1
    fi
fi

timeout_cmd() {
    local timeout=$1; shift
    "$@" &
    local pid=$!
    local count=0
    while kill -0 "$pid" 2>/dev/null; do
        [ $count -ge $((timeout * 10)) ] && kill -9 "$pid" 2>/dev/null && return 1
        sleep 0.1
        count=$((count + 1))
    done
    wait "$pid"
}

current=$(timeout_cmd 2 "$AEROSPACE" list-workspaces --focused 2>/dev/null || echo "")
[ -z "$current" ] && { echo "Failed to detect workspace" >&2; exit 1; }

if [ "$current" = "1" ]; then
    "$AEROSPACE" workspace 2
else
    "$AEROSPACE" workspace 1
fi
