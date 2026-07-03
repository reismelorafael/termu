#!/system/bin/sh
# RAFCODEPHI Termux runtime compatibility hotfix.
# Run inside the app shell after installing/updating packages if binaries stop executing.

set -u

APP_PACKAGE="${TERMUX_APP_PACKAGE:-com.termux.rafacodephi}"
PREFIX="${PREFIX:-/data/data/${APP_PACKAGE}/files/usr}"
HOME_DIR="${HOME:-/data/data/${APP_PACKAGE}/files/home}"
STATUS=0

log() { printf '%s\n' "[rafcodephi-compat] $*"; }
warn() { printf '%s\n' "[rafcodephi-compat][WARN] $*" >&2; STATUS=1; }

check_path() {
    path="$1"
    label="$2"
    if [ ! -e "$path" ]; then
        warn "missing ${label}: ${path}"
        return
    fi
    if [ ! -x "$path" ]; then
        log "repair chmod 700 ${label}: ${path}"
        chmod 700 "$path" 2>/dev/null || warn "chmod failed for ${label}: ${path}"
    fi
    if [ -x "$path" ]; then
        log "ok executable ${label}: ${path}"
    else
        warn "not executable ${label}: ${path}"
    fi
}

log "package=${APP_PACKAGE}"
log "prefix=${PREFIX}"
log "home=${HOME_DIR}"

if [ ! -d "$PREFIX" ]; then
    warn "PREFIX directory missing: ${PREFIX}"
    exit "$STATUS"
fi

if [ ! -d "$HOME_DIR" ]; then
    log "create home directory: ${HOME_DIR}"
    mkdir -p "$HOME_DIR" 2>/dev/null || warn "failed to create HOME: ${HOME_DIR}"
fi

check_path "${PREFIX}/bin/sh" "shell"
check_path "${PREFIX}/bin/pkg" "pkg"

for bin in bash apt apt-get busybox proot apkmanager shellbash busybox-safe proot-safe; do
    if [ -e "${PREFIX}/bin/${bin}" ]; then
        check_path "${PREFIX}/bin/${bin}" "${bin}"
    fi
done

if [ -d "${PREFIX}/bin" ]; then
    # Keep post-update package payloads executable when Android preserves files but loses mode bits.
    find "${PREFIX}/bin" -maxdepth 1 -type f -exec chmod 700 {} \; 2>/dev/null || warn "bulk chmod failed for ${PREFIX}/bin"
fi

if [ -d "${PREFIX}/libexec" ]; then
    find "${PREFIX}/libexec" -type f -exec chmod 700 {} \; 2>/dev/null || true
fi

if [ -d "${PREFIX}/lib/apt/methods" ]; then
    find "${PREFIX}/lib/apt/methods" -type f -exec chmod 700 {} \; 2>/dev/null || true
fi

if [ -x "${PREFIX}/bin/sh" ]; then
    "${PREFIX}/bin/sh" -c 'echo shell_exec_ok=1' || warn "shell execution probe failed"
fi

if [ -x "${PREFIX}/bin/pkg" ]; then
    "${PREFIX}/bin/pkg" --version >/dev/null 2>&1 || "${PREFIX}/bin/pkg" help >/dev/null 2>&1 || log "pkg exists; version/help probe unavailable"
fi

if [ "$STATUS" -eq 0 ]; then
    log "compatibility=PASS"
else
    warn "compatibility=NEEDS_ATTENTION"
fi

exit "$STATUS"
