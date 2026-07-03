#!/usr/bin/env bash
set -euo pipefail

abi_policy_get_prop() {
  local key="$1"
  awk -F= -v k="$key" '$1==k {gsub(/[[:space:]]/,"",$2); print $2; exit}' gradle.properties
}

abi_policy_required_csv() { abi_policy_get_prop "termux.abi.matrix"; }
abi_policy_optional_csv() { abi_policy_get_prop "termux.abi.optional"; }
abi_policy_universal() { abi_policy_get_prop "termux.abi.universal"; }

abi_policy_required_array() {
  IFS=',' read -r -a _arr <<< "$(abi_policy_required_csv)"
  for abi in "${_arr[@]}"; do
    [[ -n "${abi}" ]] && printf '%s\n' "${abi}"
  done
}

abi_policy_optional_array() {
  IFS=',' read -r -a _arr <<< "$(abi_policy_optional_csv)"
  for abi in "${_arr[@]}"; do
    [[ -n "${abi}" ]] && printf '%s\n' "${abi}"
  done
}
