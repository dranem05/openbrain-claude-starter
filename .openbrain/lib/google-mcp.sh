#!/usr/bin/env bash
# OpenBrain consolidated Google MCP launcher. Usage: google-mcp.sh <slug>
# Replaces: gmail-mcp.sh, gcal-mcp.sh, gmeet-mcp.sh, gdrive-mcp.sh, gslides-mcp.sh
set -euo pipefail
# shellcheck source=_common.sh
source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

SLUG="${1:?usage: google-mcp.sh <slug>}"
TOKEN_DIR="$HOME/.config/openbrain/tokens"
OAUTH_CLIENT="$TOKEN_DIR/oauth-client.json"
CREDS_FILE="$TOKEN_DIR/google-${SLUG}-credentials.json"
SERVER="$HOME/google-mcp/dist/index.js"

# Keep oauth-client.json in lockstep with .env (single source of truth). _common.sh
# already ran load_env, so this picks up any edit to the secret on the next spawn.
sync_oauth_client_json

[[ -f "$OAUTH_CLIENT" ]] || die "shared OAuth client missing: $OAUTH_CLIENT (run bootstrap/lib/add-google-account.sh $SLUG)"
[[ -f "$CREDS_FILE" ]] || die "per-account credentials missing: $CREDS_FILE (run add-google-account.sh)"
ensure_mcp_server "google-mcp"

exec node "$SERVER" --slug "$SLUG"
