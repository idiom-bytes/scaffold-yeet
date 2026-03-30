#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck disable=SC1091
source "$ROOT_DIR/scripts/devstack/lib.sh"

"$ROOT_DIR/scripts/devstack/ensure.sh"

if [ "${DEVSTACK_SKIP_DEPLOY:-0}" != "1" ]; then
  "$ROOT_DIR/scripts/devstack/deploy.sh"
else
  info "DEVSTACK_SKIP_DEPLOY=1, skipping deploy step"
fi

VERIFY_CMD="${DEVSTACK_VERIFY_CMD:-yarn next:check-types && yarn next:lint}"

export LOCALHOST_RPC_URL="$CHAIN_RPC_URL"
export PONDER_RPC_URL_31337="$CHAIN_RPC_URL"
export NEXT_PUBLIC_LOCAL_HARDHAT_RPC_URL="$CHAIN_RPC_URL"
export NEXT_PUBLIC_PONDER_URL="http://127.0.0.1:$PONDER_PORT"

VYPER_BIN="$(resolve_vyper_binary || true)"
if [ -n "$VYPER_BIN" ]; then
  export HARDHAT_VYPER_BINARY="$VYPER_BIN"
fi

info "running verify command: $VERIFY_CMD"
(
  cd "$ROOT_DIR"
  bash -lc "$VERIFY_CMD"
)

info "devstack verify complete"
