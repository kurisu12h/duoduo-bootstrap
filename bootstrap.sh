#!/usr/bin/env bash
set -euo pipefail

PRIVATE_REPO="kurisu12h/duoduo-vault"
TARGET_DIR="${DUODUO_TARGET_DIR:-$HOME/duoduo-vault}"
PUBLIC_REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() { printf '[duoduo-bootstrap] %s
' "$*"; }
die() { printf '[duoduo-bootstrap] ERROR: %s
' "$*" >&2; exit 1; }

clone_private_repo() {
  if [ -d "$TARGET_DIR/.git" ]; then
    log "Updating existing private vault clone at $TARGET_DIR"
    git -C "$TARGET_DIR" pull --ff-only
    return
  fi

  mkdir -p "$(dirname "$TARGET_DIR")"
  if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    log "Cloning private vault with gh..."
    gh repo clone "$PRIVATE_REPO" "$TARGET_DIR"
    return
  fi

  if [ -n "${GITHUB_TOKEN:-}" ]; then
    log "Cloning private vault with token auth..."
    git clone "https://x-access-token:${GITHUB_TOKEN}@github.com/${PRIVATE_REPO}.git" "$TARGET_DIR"
    return
  fi

  cat <<EOF >&2
[duoduo-bootstrap] No GitHub auth found.

Please do one of these first:
  1) gh auth login && gh auth setup-git
  2) export GITHUB_TOKEN=... (fine-grained token with repo read access)

Then run this script again.
EOF
  exit 1
}

clone_private_repo
cd "$TARGET_DIR"

[ -f SHA256SUMS ] || die "Missing SHA256SUMS in private vault"
[ -f bootstrap.sh ] || die "Missing bootstrap.sh in private vault"

log "Verifying private vault archives..."
sha256sum -c SHA256SUMS

log "Running private vault restore..."
bash bootstrap.sh

log "Done. If you want, run 'hermes doctor' now to confirm everything is healthy."
