#!/usr/bin/env sh
# RAFCODEPHI bootstrap/filesystem/proot/busybox/service smoke.
#
# This script is meant to be executed inside the installed RAFCODEPHI Termux app
# on a real Android device. It validates the installed filesystem contract and
# then asks TermuxService to execute a marker script through ACTION_SERVICE_EXECUTE.
#
# It does not claim performance, NEON/SIMD speedup, L1/L2 efficiency or full
# production certification. It proves only that the checked runtime contract was
# exercised on the current device/session.

set -eu

APP_ID="${RAF_APP_ID:-com.termux.rafacodephi}"
PREFIX="${PREFIX:-/data/data/${APP_ID}/files/usr}"
HOME_DIR="${HOME:-/data/data/${APP_ID}/files/home}"
SERVICE_CLASS="${RAF_SERVICE_CLASS:-${APP_ID}/com.termux.app.TermuxService}"
SERVICE_ACTION="${RAF_SERVICE_ACTION:-${APP_ID}.service_execute}"
SERVICE_FILE_SCHEME="${RAF_SERVICE_FILE_SCHEME:-${APP_ID}.file}"
EXTRA_RUNNER="${RAF_EXTRA_RUNNER:-${APP_ID}.execute.runner}"
EXTRA_SHELL_NAME="${RAF_EXTRA_SHELL_NAME:-${APP_ID}.execute.shell_name}"
EXTRA_SHELL_CREATE_MODE="${RAF_EXTRA_SHELL_CREATE_MODE:-${APP_ID}.execute.shell_create_mode}"
RUNNER_APP_SHELL="app-shell"
SHELL_CREATE_ALWAYS="always"
STAMP_DIR="${RAF_SMOKE_DIR:-${HOME_DIR}/.termux/rafcodephi-smoke}"
MARKER="${STAMP_DIR}/service-executed.ok"
SERVICE_SCRIPT="${PREFIX}/tmp/rafcodephi-service-smoke.sh"
REPORT="${STAMP_DIR}/bootstrap-filesystem-service-smoke.report"

mkdir -p "$STAMP_DIR"
: > "$REPORT"

log() {
  printf '%s\n' "$*" | tee -a "$REPORT"
}

fail() {
  log "FAIL: $*"
  exit 1
}

require_file_exec() {
  path="$1"
  label="$2"
  [ -f "$path" ] || fail "missing ${label}: ${path}"
  [ -x "$path" ] || fail "not executable ${label}: ${path}"
  log "OK: executable ${label}: ${path}"
}

require_dir() {
  path="$1"
  label="$2"
  [ -d "$path" ] || fail "missing directory ${label}: ${path}"
  log "OK: directory ${label}: ${path}"
}

log "rafcodephi_smoke=START"
log "app_id=${APP_ID}"
log "prefix=${PREFIX}"
log "home=${HOME_DIR}"
log "service=${SERVICE_CLASS}"

require_dir "$PREFIX" "PREFIX"
require_dir "${PREFIX}/bin" "PREFIX/bin"
require_dir "${PREFIX}/tmp" "PREFIX/tmp"
require_dir "${PREFIX}/var" "PREFIX/var"
require_dir "$HOME_DIR" "HOME"
require_dir "${HOME_DIR}/storage" "HOME/storage"

require_file_exec "${PREFIX}/bin/sh" "sh"
require_file_exec "${PREFIX}/bin/pkg" "pkg"
require_file_exec "${PREFIX}/bin/apkmanager" "apkmanager"
require_file_exec "${PREFIX}/bin/shellbash" "shellbash"
require_file_exec "${PREFIX}/bin/busybox-safe" "busybox-safe"
require_file_exec "${PREFIX}/bin/proot-safe" "proot-safe"

"${PREFIX}/bin/sh" -lc 'echo sh_exec_ok' >/dev/null || fail "sh execution failed"
log "OK: sh executed"

"${PREFIX}/bin/pkg" --help >/dev/null 2>&1 || fail "pkg execution failed"
log "OK: pkg executed"

"${PREFIX}/bin/apkmanager" --help >/dev/null 2>&1 || fail "apkmanager execution failed"
log "OK: apkmanager executed"

"${PREFIX}/bin/shellbash" -lc 'echo shellbash_exec_ok' >/dev/null 2>&1 || fail "shellbash execution failed"
log "OK: shellbash executed"

if "${PREFIX}/bin/busybox-safe" true >/dev/null 2>&1; then
  log "OK: busybox-safe executed real busybox"
else
  rc=$?
  [ "$rc" -eq 127 ] || fail "busybox-safe failed with unexpected rc=${rc}"
  log "TOKEN_VAZIO_OPTIONAL_BINARY: busybox-safe wrapper present but real busybox absent"
fi

if "${PREFIX}/bin/proot-safe" --help >/dev/null 2>&1; then
  log "OK: proot-safe executed real proot"
else
  rc=$?
  [ "$rc" -eq 127 ] || fail "proot-safe failed with unexpected rc=${rc}"
  log "TOKEN_VAZIO_OPTIONAL_BINARY: proot-safe wrapper present but real proot absent"
fi

rm -f "$MARKER"
cat > "$SERVICE_SCRIPT" <<EOF_SCRIPT
#!${PREFIX}/bin/sh
set -eu
mkdir -p "${STAMP_DIR}"
printf 'service_execute_ok app_id=%s prefix=%s\\n' "${APP_ID}" "${PREFIX}" > "${MARKER}"
EOF_SCRIPT
chmod 700 "$SERVICE_SCRIPT"
require_file_exec "$SERVICE_SCRIPT" "service marker script"

if ! command -v am >/dev/null 2>&1; then
  fail "Android activity manager command 'am' not found; run this inside Android/Termux device session"
fi

log "ACTION_SERVICE_EXECUTE: dispatching ${SERVICE_SCRIPT} through ${SERVICE_CLASS}"
am startservice \
  -n "$SERVICE_CLASS" \
  -a "$SERVICE_ACTION" \
  -d "${SERVICE_FILE_SCHEME}://${SERVICE_SCRIPT}" \
  --es "$EXTRA_RUNNER" "$RUNNER_APP_SHELL" \
  --es "$EXTRA_SHELL_NAME" "rafcodephi-service-smoke" \
  --es "$EXTRA_SHELL_CREATE_MODE" "$SHELL_CREATE_ALWAYS" >/dev/null

tries=0
while [ "$tries" -lt 20 ]; do
  if [ -s "$MARKER" ]; then
    log "OK: service executed marker script"
    log "marker=$(cat "$MARKER")"
    log "rafcodephi_smoke=PASS"
    log "claim_boundary=runtime_smoke_only_no_performance_claim"
    exit 0
  fi
  tries=$((tries + 1))
  sleep 1
done

fail "service marker not observed after ACTION_SERVICE_EXECUTE"
