#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
RUNTIME_DIR="${DEVSTACK_RUNTIME_DIR:-/tmp/$(basename "$ROOT_DIR")-devstack}"
PID_DIR="$RUNTIME_DIR/pids"
LOG_DIR="$RUNTIME_DIR/logs"

mkdir -p "$PID_DIR" "$LOG_DIR"

load_hardhat_env() {
  local env_file="$ROOT_DIR/packages/hardhat/.env"
  if [ -f "$env_file" ]; then
    # shellcheck disable=SC1090
    set -a; source "$env_file"; set +a
  fi
}

load_hardhat_env

CHAIN_RPC_URL="${CHAIN_RPC_URL:-${LOCALHOST_RPC_URL:-http://127.0.0.1:8545}}"
PONDER_PORT="${PONDER_PORT:-42069}"
APP_PORT="${APP_PORT:-3000}"

CHAIN_HOST="$(printf '%s' "$CHAIN_RPC_URL" | sed -E 's#^[a-z]+://([^:/]+).*$#\1#')"
CHAIN_PORT="$(printf '%s' "$CHAIN_RPC_URL" | sed -nE 's#^[a-z]+://[^:/]+:([0-9]+).*$#\1#p')"
if [ -z "$CHAIN_PORT" ]; then
  CHAIN_PORT="8545"
fi

info() {
  printf '[devstack] %s\n' "$*"
}

service_pid_file() {
  printf '%s/%s.pid' "$PID_DIR" "$1"
}

service_log_file() {
  printf '%s/%s.log' "$LOG_DIR" "$1"
}

read_service_pid() {
  local pid_file
  pid_file="$(service_pid_file "$1")"
  if [ -f "$pid_file" ]; then
    cat "$pid_file"
  fi
}

is_pid_running() {
  local pid="$1"
  [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null
}

is_port_open() {
  local host="$1"
  local port="$2"
  timeout 1 bash -lc ">/dev/tcp/$host/$port" >/dev/null 2>&1
}

is_chain_ready() {
  curl -sS --max-time 2 \
    -H 'Content-Type: application/json' \
    --data '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}' \
    "$CHAIN_RPC_URL" | grep -q '"result"'
}

wait_for_port() {
  local host="$1"
  local port="$2"
  local timeout_seconds="$3"
  local i
  for i in $(seq 1 "$timeout_seconds"); do
    if is_port_open "$host" "$port"; then
      return 0
    fi
    sleep 1
  done
  return 1
}

wait_for_chain() {
  local timeout_seconds="$1"
  local i
  for i in $(seq 1 "$timeout_seconds"); do
    if is_chain_ready; then
      return 0
    fi
    sleep 1
  done
  return 1
}

start_bg_service() {
  local name="$1"
  local cmd="$2"
  local pid_file
  local log_file

  pid_file="$(service_pid_file "$name")"
  log_file="$(service_log_file "$name")"

  local existing_pid
  existing_pid="$(read_service_pid "$name" || true)"
  if is_pid_running "$existing_pid"; then
    info "$name already running (pid=$existing_pid)"
    return 0
  fi

  info "starting $name"
  nohup bash -lc "$cmd" >>"$log_file" 2>&1 &
  echo "$!" > "$pid_file"
}

stop_service() {
  local name="$1"
  local pid
  pid="$(read_service_pid "$name" || true)"

  if ! is_pid_running "$pid"; then
    rm -f "$(service_pid_file "$name")"
    info "$name not running"
    return 0
  fi

  info "stopping $name (pid=$pid)"
  kill "$pid" 2>/dev/null || true

  local i
  for i in $(seq 1 10); do
    if ! is_pid_running "$pid"; then
      break
    fi
    sleep 1
  done

  if is_pid_running "$pid"; then
    kill -9 "$pid" 2>/dev/null || true
  fi

  rm -f "$(service_pid_file "$name")"
}

resolve_vyper_binary() {
  if [ -n "${HARDHAT_VYPER_BINARY:-}" ] && [ -x "${HARDHAT_VYPER_BINARY}" ]; then
    printf '%s' "$HARDHAT_VYPER_BINARY"
    return 0
  fi

  if [ -x "$ROOT_DIR/packages/hardhat/.venv/bin/vyper" ]; then
    printf '%s' "$ROOT_DIR/packages/hardhat/.venv/bin/vyper"
    return 0
  fi

  if [ -x "$ROOT_DIR/.venv/bin/vyper" ]; then
    printf '%s' "$ROOT_DIR/.venv/bin/vyper"
    return 0
  fi

  if command -v vyper >/dev/null 2>&1; then
    command -v vyper
    return 0
  fi

  return 1
}
