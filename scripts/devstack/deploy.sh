#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck disable=SC1091
source "$ROOT_DIR/scripts/devstack/lib.sh"

if ! is_chain_ready; then
  info "chain not ready at $CHAIN_RPC_URL; starting devstack first"
  "$ROOT_DIR/scripts/devstack/up.sh"
fi

VYPER_BIN="$(resolve_vyper_binary || true)"
if [ -z "$VYPER_BIN" ]; then
  info "could not resolve vyper binary; deploy may fail if hardhat cache compiler is not executable"
else
  info "using vyper binary: $VYPER_BIN"
fi

export LOCALHOST_RPC_URL="$CHAIN_RPC_URL"
export PONDER_RPC_URL_31337="$CHAIN_RPC_URL"
if [ -n "$VYPER_BIN" ]; then
  export HARDHAT_VYPER_BINARY="$VYPER_BIN"
fi

DEPLOY_LOG="$LOG_DIR/deploy.log"
info "deploying to localhost via $CHAIN_RPC_URL"
(
  cd "$ROOT_DIR"
  yarn deploy --network localhost
) | tee "$DEPLOY_LOG"

info "deploy complete (log: $DEPLOY_LOG)"
