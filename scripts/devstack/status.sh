#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck disable=SC1091
source "$ROOT_DIR/scripts/devstack/lib.sh"

status_line() {
  local name="$1"
  local host="$2"
  local port="$3"
  local pid
  pid="$(read_service_pid "$name" || true)"

  local pid_state="down"
  if is_pid_running "$pid"; then
    pid_state="up(pid=$pid)"
  fi

  local port_state="closed"
  if is_port_open "$host" "$port"; then
    port_state="open"
  fi

  printf '%-8s %-20s %-6s log=%s\n' "$name" "$pid_state" "$port_state" "$(service_log_file "$name")"
}

printf 'runtime=%s\n' "$RUNTIME_DIR"
printf 'chain_rpc=%s\n' "$CHAIN_RPC_URL"
status_line chain "$CHAIN_HOST" "$CHAIN_PORT"
status_line ponder "127.0.0.1" "$PONDER_PORT"
status_line app "127.0.0.1" "$APP_PORT"
