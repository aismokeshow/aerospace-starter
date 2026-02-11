#!/usr/bin/env bash
# toggle.sh — Toggle between workspace 1 and 2
# aismokeshow // aismokeshow.com

set -euo pipefail

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

current=$(timeout_cmd 2 aerospace list-workspaces --focused 2>/dev/null || echo "")
[ -z "$current" ] && { echo "Failed to detect workspace" >&2; exit 1; }

if [ "$current" = "1" ]; then
    aerospace workspace 2
else
    aerospace workspace 1
fi
