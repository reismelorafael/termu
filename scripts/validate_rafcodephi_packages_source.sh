#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

REPO_URL="${TERMUX_PACKAGES_RAF_REPO:-https://github.com/exacordex-crypto/termux-packagesRafcodephi.git}"
REPO_REF="${TERMUX_PACKAGES_RAF_REF:-dfd7ce0791bbdacbff61f4b67933ef608d6d180c}"
OUT_DIR="${TERMUX_PACKAGES_RAF_MANIFEST_DIR:-dist/source-contract}"
REQUIRE_PINNED="${TERMUX_PACKAGES_RAF_REQUIRE_PINNED:-true}"

fail() { printf '[raf-packages-source] ERROR: %s\n' "$*" >&2; exit 1; }
info() { printf '[raf-packages-source] %s\n' "$*"; }

case "$REPO_URL" in
  https://github.com/exacordex-crypto/termux-packagesRafcodephi|https://github.com/exacordex-crypto/termux-packagesRafcodephi.git) ;;
  *) fail "TERMUX_PACKAGES_RAF_REPO must point to exacordex-crypto/termux-packagesRafcodephi, got: ${REPO_URL}" ;;
esac

if [[ "$REQUIRE_PINNED" == "true" && ! "$REPO_REF" =~ ^[0-9a-f]{40}$ ]]; then
  fail "TERMUX_PACKAGES_RAF_REF must be a pinned 40-char commit for reproducible CI; got: ${REPO_REF}"
fi

resolved=""
if [[ "$REPO_REF" =~ ^[0-9a-f]{40}$ ]]; then
  if git ls-remote --exit-code "$REPO_URL" "$REPO_REF" >/dev/null 2>&1; then
    resolved="$REPO_REF"
  else
    # GitHub ls-remote may not advertise raw SHA objects; verify against all refs without cloning.
    if git ls-remote "$REPO_URL" | awk '{print $1}' | grep -Fxq "$REPO_REF"; then
      resolved="$REPO_REF"
    else
      fail "pinned commit not advertised by ${REPO_URL}: ${REPO_REF}"
    fi
  fi
else
  resolved="$(git ls-remote --exit-code "$REPO_URL" "$REPO_REF" | awk 'NR==1{print $1}')"
  [[ -n "$resolved" ]] || fail "unable to resolve ref ${REPO_REF} from ${REPO_URL}"
fi

mkdir -p "$OUT_DIR"
cat > "${OUT_DIR}/TERMUX_PACKAGES_RAFCODEPHI_SOURCE.env" <<MANIFEST
TERMUX_PACKAGES_RAF_REPO=${REPO_URL}
TERMUX_PACKAGES_RAF_REF=${REPO_REF}
TERMUX_PACKAGES_RAF_RESOLVED_COMMIT=${resolved}
TERMUX_PACKAGES_RAF_ABIS=armeabi-v7a,arm64-v8a
TERMUX_PACKAGES_RAF_ROLE=source-only-packages-and-bootstrap
TERMUX_PACKAGES_RAF_BINARIES_CREATED_BY_CI_ONLY=1
MANIFEST

info "repo=${REPO_URL}"
info "ref=${REPO_REF}"
info "resolved_commit=${resolved}"
info "manifest=${OUT_DIR}/TERMUX_PACKAGES_RAFCODEPHI_SOURCE.env"
