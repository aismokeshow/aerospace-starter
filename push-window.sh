#!/usr/bin/env bash
# Push focused window to the other workspace (1↔2) — aismokeshow

timeout_cmd() {
    local timeout=$1; shift
    "$@" &
    local pid=$!
    local count=0
    while kill -0 $pid 2>/dev/null; do
        [ $count -ge $((timeout * 10)) ] && kill -9 $pid 2>/dev/null && return 1
        sleep 0.1
        count=$((count + 1))
    done
    wait $pid
}

current=$(timeout_cmd 2 aerospace list-workspaces --focused 2>/dev/null || echo "")
[ -z "$current" ] && exit 1

if [ "$current" = "1" ]; then
    aerospace move-node-to-workspace 2
elif [ "$current" = "2" ]; then
    aerospace move-node-to-workspace 1
fi
