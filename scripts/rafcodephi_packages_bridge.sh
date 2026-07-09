#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGES_REPO_URL="${RAFCODEPHI_PACKAGES_REPO_URL:-https://github.com/exacordex-crypto/termux-packagesRafcodephi.git}"
PACKAGES_DIR="${RAFCODEPHI_PACKAGES_DIR:-${ROOT_DIR}/out/termux-packagesRafcodephi}"
OUT_DIR="${ROOT_DIR}/out/rafcodephi-packages-bridge"
REQUIRED_PACKAGES=(apt bash busybox proot dpkg ca-certificates coreutils termux-tools)
REQUIRED_ARCHES=(aarch64 arm)

info() { printf '[rafcodephi-packages-bridge] %s\n' "$*"; }
fail() { printf '[rafcodephi-packages-bridge][ERROR] %s\n' "$*" >&2; exit 1; }

ensure_repo() {
  mkdir -p "$(dirname "$PACKAGES_DIR")" "$OUT_DIR"
  if [[ -d "${PACKAGES_DIR}/.git" ]]; then
    info "using existing packages repo: ${PACKAGES_DIR}"
    git -C "$PACKAGES_DIR" fetch --depth 1 origin master >/dev/null 2>&1 || true
    git -C "$PACKAGES_DIR" checkout -q master || true
    git -C "$PACKAGES_DIR" pull --ff-only --depth 1 origin master >/dev/null 2>&1 || true
  else
    info "cloning packages repo: ${PACKAGES_REPO_URL}"
    rm -rf "$PACKAGES_DIR"
    git clone --depth 1 "$PACKAGES_REPO_URL" "$PACKAGES_DIR"
  fi
}

validate_recipe() {
  local pkg="$1"
  local recipe="${PACKAGES_DIR}/packages/${pkg}/build.sh"
  [[ -f "$recipe" ]] || fail "missing package recipe: packages/${pkg}/build.sh"
  grep -q 'TERMUX_PKG_VERSION' "$recipe" || fail "recipe missing TERMUX_PKG_VERSION: ${pkg}"
  info "recipe ok: ${pkg}"
}

validate_contract() {
  ensure_repo
  for pkg in "${REQUIRED_PACKAGES[@]}"; do
    validate_recipe "$pkg"
  done
  [[ -f "${PACKAGES_DIR}/.github/workflows/packages.yml" ]] || fail "missing packages workflow"
  for arch in "${REQUIRED_ARCHES[@]}"; do
    grep -q "$arch" "${PACKAGES_DIR}/.github/workflows/packages.yml" || fail "workflow missing arch: ${arch}"
  done
  printf '%s\n' "${REQUIRED_PACKAGES[@]}" > "${OUT_DIR}/required-packages.txt"
  printf '%s\n' "${REQUIRED_ARCHES[@]}" > "${OUT_DIR}/required-arches.txt"
  git -C "$PACKAGES_DIR" rev-parse HEAD > "${OUT_DIR}/packages-repo-head.txt"
  info "contract=PASS"
}

emit_dispatch_plan() {
  validate_contract
  cat > "${OUT_DIR}/workflow-dispatch-packages.txt" <<EOF
packages: ${REQUIRED_PACKAGES[*]}
free-space: false
workflow: Packages
repository: ${PACKAGES_REPO_URL}
EOF
  info "dispatch plan: ${OUT_DIR}/workflow-dispatch-packages.txt"
}

case "${1:-validate}" in
  validate) validate_contract ;;
  plan|dispatch-plan) emit_dispatch_plan ;;
  *) fail "usage: $0 [validate|plan]" ;;
esac
