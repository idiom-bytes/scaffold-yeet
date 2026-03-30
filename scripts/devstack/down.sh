#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck disable=SC1091
source "$ROOT_DIR/scripts/devstack/lib.sh"

stop_service app
stop_service ponder
stop_service chain

info "devstack down complete"
