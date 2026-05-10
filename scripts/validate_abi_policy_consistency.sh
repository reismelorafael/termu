#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
source "$ROOT_DIR/scripts/abi_policy_lib.sh"

fail(){ echo "[abi-policy] ERROR: $*" >&2; exit 1; }

required_csv="$(abi_policy_required_csv)"
optional_csv="$(abi_policy_optional_csv)"
expected_csv="$required_csv,$optional_csv"

for file in app/build.gradle terminal-emulator/build.gradle scripts/build_apk_matrix.sh scripts/bootstrap_lowlevel_sync_check.sh README.md; do
  [[ -f "$file" ]] || fail "missing $file"
done

rg -q "termux\.abi\.matrix" app/build.gradle || fail "app/build.gradle must consume canonical property termux.abi.matrix"
rg -q "termux\.abi\.optional" app/build.gradle || fail "app/build.gradle must consume canonical property termux.abi.optional"
rg -q "termux\.abi\.matrix" terminal-emulator/build.gradle || fail "terminal-emulator/build.gradle must consume canonical property termux.abi.matrix"

for abi in ${required_csv//,/ }; do
  rg -q "$abi" README.md || fail "README.md missing required ABI ${abi}"
done
for abi in ${optional_csv//,/ }; do
  rg -q "$abi" README.md || fail "README.md missing optional ABI ${abi}"
done

rg -q "abi_policy_required_array" scripts/build_apk_matrix.sh || fail "build_apk_matrix.sh must validate required ABI set from canonical policy"
rg -q "abi_policy_required_array" scripts/bootstrap_lowlevel_sync_check.sh || fail "bootstrap_lowlevel_sync_check.sh must validate required ABI set from canonical policy"

echo "[abi-policy] OK canonical ABI policy is consistent (${expected_csv})."
