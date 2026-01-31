#!/usr/bin/env bash
# boom.sh — Lightweight AeroSpace reload with validation
# Usage: boom.sh or via shell alias (see README)
# aismokeshow // aismokeshow.com

set -euo pipefail

readonly SCRIPT_NAME="$(basename "$0")"
readonly LOCKFILE="/tmp/${SCRIPT_NAME}.lock"
readonly STARTUP_TIMEOUT=10

# ── Colors ──────────────────────────────────────────────────
if [[ -t 1 ]] && command -v tput >/dev/null 2>&1 && tput colors >/dev/null 2>&1; then
    readonly RED='\033[0;31m' GREEN='\033[0;32m' BLUE='\033[0;34m'
    readonly YELLOW='\033[1;33m' NC='\033[0m'
else
    readonly RED='' GREEN='' BLUE='' YELLOW='' NC=''
fi

log_info()    { echo -e "${BLUE}▸${NC} $*" >&2; }
log_success() { echo -e "${GREEN}✓${NC} $*" >&2; }
log_error()   { echo -e "${RED}✗${NC} $*" >&2; }
log_warn()    { echo -e "${YELLOW}⚠${NC} $*" >&2; }

# ── Cleanup ─────────────────────────────────────────────────
cleanup() {
    rm -f "$LOCKFILE"
}
trap cleanup EXIT INT TERM

# ── Lock (prevent concurrent runs) ─────────────────────────
acquire_lock() {
    if [[ -f "$LOCKFILE" ]]; then
        local lock_pid
        lock_pid=$(cat "$LOCKFILE" 2>/dev/null || echo "")
        if [[ -n "$lock_pid" ]] && kill -0 "$lock_pid" 2>/dev/null; then
            log_error "Already running (PID: $lock_pid)"
            return 1
        fi
        rm -f "$LOCKFILE"
    fi
    echo $$ > "$LOCKFILE"
}

# ── AeroSpace helpers ───────────────────────────────────────
is_running()    { pgrep -x AeroSpace >/dev/null 2>&1; }
is_responsive() { aerospace list-workspaces --all >/dev/null 2>&1; }

start_aerospace() {
    log_info "Starting AeroSpace..."
    open -a AeroSpace 2>/dev/null || { log_error "Failed to launch AeroSpace.app"; return 1; }

    local elapsed=0
    while [[ $elapsed -lt $STARTUP_TIMEOUT ]]; do
        sleep 1
        ((elapsed++))
        if is_responsive; then
            log_success "AeroSpace ready (${elapsed}s)"
            return 0
        fi
    done

    log_error "AeroSpace not responsive after ${STARTUP_TIMEOUT}s"
    return 1
}

ensure_running() {
    if is_running && is_responsive; then
        return 0
    fi

    if is_running && ! is_responsive; then
        log_warn "AeroSpace unresponsive, restarting..."
        killall AeroSpace 2>/dev/null || true
        sleep 2
    fi

    start_aerospace
}

# ── Main ────────────────────────────────────────────────────
main() {
    echo ""
    log_info "Reloading AeroSpace..."
    echo ""

    # Pre-flight
    if ! command -v aerospace >/dev/null 2>&1; then
        log_error "aerospace CLI not found. Is AeroSpace installed?"
        return 1
    fi
    acquire_lock || return 1

    # Ensure running, then reload
    ensure_running || return 1

    log_info "Reloading config..."
    if ! aerospace reload-config 2>&1; then
        log_error "Config reload failed"
        return 1
    fi
    log_success "Config reloaded"

    # Quick health check
    sleep 0.5
    if is_responsive; then
        local ws_count
        ws_count=$(aerospace list-workspaces --all 2>/dev/null | wc -l | tr -d ' ')
        log_success "AeroSpace operational (${ws_count} workspaces)"
    else
        log_error "AeroSpace not responsive after reload"
        return 1
    fi

    echo ""
    return 0
}

main "$@"
