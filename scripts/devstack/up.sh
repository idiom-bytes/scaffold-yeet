#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck disable=SC1091
source "$ROOT_DIR/scripts/devstack/lib.sh"

ensure_chain() {
  if is_chain_ready; then
    info "chain ready at $CHAIN_RPC_URL"
    return 0
  fi

  start_bg_service "chain" "cd '$ROOT_DIR' && yarn workspace @se-2/hardhat hardhat node --network hardhat --no-deploy --port '$CHAIN_PORT'"

  if ! wait_for_chain 30; then
    info "chain failed to become ready. tail $LOG_DIR/chain.log"
    return 1
  fi

  info "chain started at $CHAIN_RPC_URL"
}

ensure_ponder() {
  if is_port_open 127.0.0.1 "$PONDER_PORT"; then
    info "ponder reachable on port $PONDER_PORT"
    return 0
  fi

  start_bg_service "ponder" "cd '$ROOT_DIR' && PONDER_RPC_URL_31337='$CHAIN_RPC_URL' yarn ponder:dev"

  if ! wait_for_port 127.0.0.1 "$PONDER_PORT" 30; then
    info "ponder failed to start. tail $LOG_DIR/ponder.log"
    return 1
  fi

  info "ponder started on port $PONDER_PORT"
}

ensure_app() {
  if is_port_open 127.0.0.1 "$APP_PORT"; then
    info "app reachable on port $APP_PORT"
    return 0
  fi

  start_bg_service "app" "cd '$ROOT_DIR' && NEXT_PUBLIC_LOCAL_HARDHAT_RPC_URL='$CHAIN_RPC_URL' NEXT_PUBLIC_PONDER_URL='http://127.0.0.1:$PONDER_PORT' yarn start"

  if ! wait_for_port 127.0.0.1 "$APP_PORT" 45; then
    info "app failed to start. tail $LOG_DIR/app.log"
    return 1
  fi

  info "app started on port $APP_PORT"
}

info "runtime dir: $RUNTIME_DIR"
ensure_chain
ensure_ponder
if [ "${DEVSTACK_SKIP_APP:-0}" != "1" ]; then
  ensure_app
else
  info "DEVSTACK_SKIP_APP=1, skipping app startup"
fi

info "devstack up complete"
