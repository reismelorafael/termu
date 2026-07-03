#!/usr/bin/env bash
set -euo pipefail

root=".github/workflows"
status=0

if [[ ! -d "$root" ]]; then
  echo "[ERROR] workflow directory not found: $root"
  exit 1
fi

shopt -s nullglob
workflows=("$root"/*.yml "$root"/*.yaml)
shopt -u nullglob

if [[ ${#workflows[@]} -eq 0 ]]; then
  echo "[ERROR] no GitHub Actions workflow files found in $root"
  exit 1
fi

for wf in "${workflows[@]}"; do
  track=$(sed -n 's/^# ci_track:[[:space:]]*//p' "$wf" | head -n1 | tr -d '\r')
  abis=$(sed -n 's/^# ci_abis:[[:space:]]*//p' "$wf" | head -n1 | tr -d '\r')

  if [[ -z "$track" ]]; then
    echo "[ERROR] missing # ci_track in $wf"
    status=1
  fi
  if [[ -z "$abis" ]]; then
    echo "[ERROR] missing # ci_abis in $wf"
    status=1
  fi

  if [[ -n "$track" ]]; then
    case "$track" in
      debug|internal|official|ops|deprecated) ;;
      *)
        echo "[ERROR] invalid ci_track '$track' in $wf"
        status=1
        ;;
    esac
  fi

done

if [[ $status -ne 0 ]]; then
  exit $status
fi

echo "[OK] workflow metadata contract validated (${#workflows[@]} workflows)"
