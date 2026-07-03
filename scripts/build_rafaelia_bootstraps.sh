#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

: "${TERMUX_BOOTSTRAP_PACKAGE_NAME:=com.termux.rafacodephi}"
: "${TERMUX_BOOTSTRAP_PAGE_SIZE:=16384}"

builder="${TMPDIR:-/tmp}/bootstrap_zip_builder.$$"
generated_root="${ROOT_DIR}/build/generated/rafaelia-bootstrap/common"
prefix="/data/data/${TERMUX_BOOTSTRAP_PACKAGE_NAME}/files/usr"
trap 'rm -f "$builder"' EXIT

mkdir -p "${generated_root}/bin" "${generated_root}/etc" app/src/main/cpp

cat > "${generated_root}/bin/sh" <<'EOS'
#!/system/bin/sh
# RAFCODEPHI bootstrap shell launcher.
# Prefer a real Termux shell after updates; otherwise fall back to Android sh.
PREFIX="${PREFIX:-/data/data/com.termux.rafacodephi/files/usr}"
if [ -x "${PREFIX}/bin/bash" ]; then
    exec "${PREFIX}/bin/bash" "$@"
fi
if [ -x /system/bin/sh ]; then
    exec /system/bin/sh "$@"
fi
echo 'no executable shell backend found' >&2
exit 127
EOS

cat > "${generated_root}/bin/pkg" <<'EOS'
#!/system/bin/sh
# RAFCODEPHI pkg compatibility wrapper.
# It delegates to real apt/pkg backends when package updates install them.
PREFIX="${PREFIX:-/data/data/com.termux.rafacodephi/files/usr}"
cmd="${1:-help}"

if [ "$cmd" = "--version" ] || [ "$cmd" = "version" ]; then
    echo 'RAFCODEPHI pkg bootstrap-wrapper 1.0'
    if [ -x "${PREFIX}/bin/apt" ]; then "${PREFIX}/bin/apt" --version 2>/dev/null || true; fi
    exit 0
fi

if [ "$cmd" = "help" ] || [ "$cmd" = "-h" ] || [ "$cmd" = "--help" ]; then
    cat <<'HELP'
RAFCODEPHI pkg bootstrap wrapper
Usage: pkg <command> [args]
Delegates to $PREFIX/bin/apt or $PREFIX/bin/apt-get when available.
Supported bootstrap commands: help, --version, update, upgrade, install, search, list-all, show.
HELP
    exit 0
fi

if [ -x "${PREFIX}/bin/apt" ]; then
    exec "${PREFIX}/bin/apt" "$@"
fi
if [ -x "${PREFIX}/bin/apt-get" ]; then
    exec "${PREFIX}/bin/apt-get" "$@"
fi

echo 'pkg backend not installed yet: apt/apt-get missing in $PREFIX/bin' >&2
echo 'bootstrap shell is alive; install a real Termux package backend before package operations.' >&2
exit 127
EOS

cat > "${generated_root}/bin/busybox" <<'EOS'
#!/system/bin/sh
# RAFCODEPHI busybox compatibility wrapper.
# Delegates common applets to Android toybox/toolbox until a real busybox is installed.
if [ "${1:-}" = "--help" ] || [ "${1:-}" = "help" ]; then
    echo 'RAFCODEPHI busybox bootstrap-wrapper; delegates to toybox/toolbox when available.'
    exit 0
fi
if [ "${1:-}" = "--version" ]; then
    echo 'RAFCODEPHI busybox bootstrap-wrapper 1.0'
    exit 0
fi
if [ $# -eq 0 ]; then
    echo 'busybox wrapper requires an applet name' >&2
    exit 1
fi
applet="$1"
shift
if command -v toybox >/dev/null 2>&1; then
    exec toybox "$applet" "$@"
fi
if command -v toolbox >/dev/null 2>&1; then
    exec toolbox "$applet" "$@"
fi
if command -v "$applet" >/dev/null 2>&1; then
    exec "$applet" "$@"
fi
echo "no backend for busybox applet: ${applet}" >&2
exit 127
EOS

cat > "${generated_root}/bin/proot" <<'EOS'
#!/system/bin/sh
# RAFCODEPHI proot compatibility wrapper.
# This wrapper is intentionally honest: proot needs a real native binary.
PREFIX="${PREFIX:-/data/data/com.termux.rafacodephi/files/usr}"
for candidate in "${PREFIX}/bin/proot.real" "${PREFIX}/libexec/proot"; do
    if [ -x "$candidate" ]; then
        exec "$candidate" "$@"
    fi
done
if [ "${1:-}" = "--version" ] || [ "${1:-}" = "--help" ] || [ "${1:-}" = "help" ]; then
    echo 'RAFCODEPHI proot bootstrap-wrapper: real proot native binary not installed yet.'
    exit 0
fi
echo 'real proot native binary not installed; cannot emulate proot with a shell wrapper' >&2
exit 127
EOS

cat > "${generated_root}/bin/apt" <<EOS
#!${prefix}/bin/sh
# RAFCODEPHI apt compatibility shim.
exec "${prefix}/bin/pkg" "\$@"
EOS

cat > "${generated_root}/bin/apt-get" <<EOS
#!${prefix}/bin/sh
# RAFCODEPHI apt-get compatibility shim.
exec "${prefix}/bin/pkg" "\$@"
EOS

cat > "${generated_root}/bin/apkmanager" <<EOS
#!${prefix}/bin/sh
# RAFCODEPHI bootstrap package-manager shim.
exec "${prefix}/bin/pkg" "\$@"
EOS

cat > "${generated_root}/bin/shellbash" <<EOS
#!${prefix}/bin/sh
# RAFCODEPHI shell launcher. Prefer bash when present; otherwise use bootstrap sh.
if [ -x "${prefix}/bin/bash" ]; then
    exec "${prefix}/bin/bash" "\$@"
fi
exec "${prefix}/bin/sh" "\$@"
EOS

cat > "${generated_root}/bin/busybox-safe" <<EOS
#!${prefix}/bin/sh
# Busybox safe launcher.
exec "${prefix}/bin/busybox" "\$@"
EOS

cat > "${generated_root}/bin/proot-safe" <<EOS
#!${prefix}/bin/sh
# Proot safe launcher.
exec "${prefix}/bin/proot" "\$@"
EOS

cat > "${generated_root}/etc/motd" <<'EOS'
RAFCODEPHI bootstrap payload
Commands are compatibility wrappers until real Termux packages update the prefix.
EOS
chmod 700 "${generated_root}/bin/sh" "${generated_root}/bin/pkg" "${generated_root}/bin/busybox" "${generated_root}/bin/proot" \
    "${generated_root}/bin/apt" "${generated_root}/bin/apt-get" "${generated_root}/bin/apkmanager" "${generated_root}/bin/shellbash" \
    "${generated_root}/bin/busybox-safe" "${generated_root}/bin/proot-safe"
chmod 600 "${generated_root}/etc/motd"

cc -O2 -std=c11 -Wall -Wextra -Werror scripts/bootstrap_zip_builder.c -o "$builder"
RAF_BOOTSTRAP_SRC_DIR="$generated_root" TERMUX_BOOTSTRAP_PACKAGE_NAME="$TERMUX_BOOTSTRAP_PACKAGE_NAME" TERMUX_BOOTSTRAP_PAGE_SIZE="$TERMUX_BOOTSTRAP_PAGE_SIZE" "$builder" app/src/main/cpp/bootstrap-aarch64.zip aarch64
RAF_BOOTSTRAP_SRC_DIR="$generated_root" TERMUX_BOOTSTRAP_PACKAGE_NAME="$TERMUX_BOOTSTRAP_PACKAGE_NAME" TERMUX_BOOTSTRAP_PAGE_SIZE="$TERMUX_BOOTSTRAP_PAGE_SIZE" "$builder" app/src/main/cpp/bootstrap-arm.zip arm
RAF_BOOTSTRAP_SRC_DIR="$generated_root" TERMUX_BOOTSTRAP_PACKAGE_NAME="$TERMUX_BOOTSTRAP_PACKAGE_NAME" TERMUX_BOOTSTRAP_PAGE_SIZE="$TERMUX_BOOTSTRAP_PAGE_SIZE" "$builder" app/src/main/cpp/bootstrap-i686.zip i686
RAF_BOOTSTRAP_SRC_DIR="$generated_root" TERMUX_BOOTSTRAP_PACKAGE_NAME="$TERMUX_BOOTSTRAP_PACKAGE_NAME" TERMUX_BOOTSTRAP_PAGE_SIZE="$TERMUX_BOOTSTRAP_PAGE_SIZE" "$builder" app/src/main/cpp/bootstrap-x86_64.zip x86_64

# The native ASM embedder consumes rewritten-bootstrap-*.zip so local/dev mode must
# mirror its already-runtime-ready payloads to the same canonical names.
cp app/src/main/cpp/bootstrap-aarch64.zip app/src/main/cpp/rewritten-bootstrap-aarch64.zip
cp app/src/main/cpp/bootstrap-arm.zip app/src/main/cpp/rewritten-bootstrap-arm.zip
cp app/src/main/cpp/bootstrap-i686.zip app/src/main/cpp/rewritten-bootstrap-i686.zip
cp app/src/main/cpp/bootstrap-x86_64.zip app/src/main/cpp/rewritten-bootstrap-x86_64.zip

echo "RAFCODEPHI bootstraps generated for package=${TERMUX_BOOTSTRAP_PACKAGE_NAME} page_size=${TERMUX_BOOTSTRAP_PAGE_SIZE} payload=${generated_root}"
