#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
mkdir -p reports

PACKAGE_NAME="${RAFCODEPHI_PACKAGE_NAME:-com.termux.rafacodephi}"
REQUIRE_REAL_PKG="${REQUIRE_REAL_PKG:-false}"
TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
REPORT_JSON="reports/device_pkg_smoke.json"
REPORT_MD="reports/device_pkg_smoke.md"
REPORT_LOG="reports/device_pkg_smoke.log"

status="DEVICE_PENDING"
reason="pending"
model="pending"
abi="pending"
sdk="pending"
minimal_exit="pending"
real_pkg_exit="not_requested"

write_reports() {
  jq -n \
    --arg timestamp_utc "$TS" \
    --arg package_name "$PACKAGE_NAME" \
    --arg device_model "$model" \
    --arg abi "$abi" \
    --arg sdk "$sdk" \
    --arg require_real_pkg "$REQUIRE_REAL_PKG" \
    --arg minimal_exit "$minimal_exit" \
    --arg real_pkg_exit "$real_pkg_exit" \
    --arg final_status "$status" \
    --arg reason "$reason" \
    '{timestamp_utc:$timestamp_utc,package_name:$package_name,device_model:$device_model,abi:$abi,sdk:$sdk,require_real_pkg:$require_real_pkg,minimal_exit:$minimal_exit,real_pkg_exit:$real_pkg_exit,final_status:$final_status,reason:$reason}' \
    > "$REPORT_JSON"

  cat > "$REPORT_MD" <<MD
# Device pkg smoke

- timestamp_utc: $TS
- package_name: $PACKAGE_NAME
- device_model: $model
- abi: $abi
- sdk: $sdk
- REQUIRE_REAL_PKG: $REQUIRE_REAL_PKG
- minimal_exit: $minimal_exit
- real_pkg_exit: $real_pkg_exit
- final_status: $status
- reason: $reason

See also: `$REPORT_LOG`.
MD
}

if ! command -v adb >/dev/null 2>&1; then
  echo "adb_not_found" > "$REPORT_LOG"
  status="DEVICE_PENDING"
  reason="adb_not_found"
  write_reports
  if [[ "$REQUIRE_REAL_PKG" == "true" ]]; then
    echo "REQUIRE_REAL_PKG=true but adb is not available" >&2
    exit 1
  fi
  exit 0
fi

dev="$(adb devices | awk 'NR>1 && $2=="device"{print $1; exit}')"
if [[ -z "$dev" ]]; then
  echo "no_connected_device" > "$REPORT_LOG"
  status="DEVICE_PENDING"
  reason="no_connected_device"
  write_reports
  if [[ "$REQUIRE_REAL_PKG" == "true" ]]; then
    echo "REQUIRE_REAL_PKG=true but no connected device is available" >&2
    exit 1
  fi
  exit 0
fi

model="$(adb shell getprop ro.product.model | tr -d '\r')"
abi="$(adb shell getprop ro.product.cpu.abi | tr -d '\r')"
sdk="$(adb shell getprop ro.build.version.sdk | tr -d '\r')"

cat > /tmp/rafcodephi-device-pkg-smoke.sh <<'DEVICE_SH'
set +e
PREFIX="/data/data/com.termux.rafacodephi/files/usr"
HOME="/data/data/com.termux.rafacodephi/files/home"
export PREFIX HOME
export PATH="$PREFIX/bin:/system/bin:/system/xbin:/apex/com.android.runtime/bin"

echo "=== identity ==="
echo "PWD=$PWD"
echo "HOME=$HOME"
echo "PREFIX=$PREFIX"
echo "PATH=$PATH"

fail=0
check(){
  name="$1"
  shift
  echo "=== $name ==="
  "$@"
  code=$?
  echo "exit_$name=$code"
  if [ "$code" != "0" ]; then fail=1; fi
}

check cat_help cat --help
check ls_home ls "$HOME"
check clear clear

echo "=== grep ==="
grep x /dev/null >/dev/null 2>&1
g=$?
echo "exit_grep=$g"
if [ "$g" != "0" ] && [ "$g" != "1" ]; then fail=1; fi

check pkg_help pkg help
check apt_help apt help

if [ "$fail" = "0" ]; then
  echo "MINIMAL_PKG_LAYER=PASS"
  exit 0
fi

echo "MINIMAL_PKG_LAYER=FAIL"
exit 1
DEVICE_SH

adb push /tmp/rafcodephi-device-pkg-smoke.sh /data/local/tmp/rafcodephi-device-pkg-smoke.sh >/dev/null
adb shell chmod 755 /data/local/tmp/rafcodephi-device-pkg-smoke.sh >/dev/null

if adb shell run-as "$PACKAGE_NAME" sh /data/local/tmp/rafcodephi-device-pkg-smoke.sh > "$REPORT_LOG" 2>&1; then
  minimal_exit="0"
  status="DEVICE_MINIMAL_PKG_LAYER_VALIDATED"
  reason="minimal_pkg_layer_passed"
else
  minimal_exit="$?"
  status="DEVICE_FAILED"
  reason="minimal_pkg_layer_failed"
fi

if [[ "$REQUIRE_REAL_PKG" == "true" ]]; then
  cat > /tmp/rafcodephi-real-pkg-smoke.sh <<'REAL_PKG_SH'
set -e
PREFIX="/data/data/com.termux.rafacodephi/files/usr"
HOME="/data/data/com.termux.rafacodephi/files/home"
export PREFIX HOME
export PATH="$PREFIX/bin:/system/bin:/system/xbin:/apex/com.android.runtime/bin"

echo "=== real pkg smoke ==="
pkg update -y
pkg install -y nano
nano --version
pkg install -y python
python --version
pkg install -y git
git --version
REAL_PKG_SH
  adb push /tmp/rafcodephi-real-pkg-smoke.sh /data/local/tmp/rafcodephi-real-pkg-smoke.sh >/dev/null
  adb shell chmod 755 /data/local/tmp/rafcodephi-real-pkg-smoke.sh >/dev/null
  if adb shell run-as "$PACKAGE_NAME" sh /data/local/tmp/rafcodephi-real-pkg-smoke.sh >> "$REPORT_LOG" 2>&1; then
    real_pkg_exit="0"
    status="DEVICE_REAL_PKG_VALIDATED"
    reason="pkg_update_install_nano_python_git_passed"
  else
    real_pkg_exit="$?"
    status="DEVICE_FAILED"
    reason="real_pkg_update_install_failed"
  fi
fi

write_reports

if [[ "$REQUIRE_REAL_PKG" == "true" && "$status" != "DEVICE_REAL_PKG_VALIDATED" ]]; then
  echo "REQUIRE_REAL_PKG=true final_status=$status reason=$reason" >&2
  exit 1
fi

if [[ "$status" == "DEVICE_FAILED" ]]; then
  exit 1
fi

exit 0
