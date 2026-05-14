#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

BASE_REF="${1:-${GITHUB_BASE_REF:-}}"
if [[ -n "$BASE_REF" ]]; then
  git fetch --depth=1 origin "$BASE_REF" >/dev/null 2>&1 || true
  DIFF_RANGE="origin/$BASE_REF...HEAD"
else
  DIFF_RANGE="HEAD~1...HEAD"
fi

added_files="$(git diff --name-status "$DIFF_RANGE" | awk '$1=="A"{print $2}' | rg '^Arme/Add/.*\.(c|S|h)$' || true)"
[[ -z "$added_files" ]] && { echo "OK: sem novos .c/.S/.h em Arme/Add/"; exit 0; }

missing=0
while IFS= read -r file; do
  if ! python3 - "$file" <<'PY'
import json, sys
f = sys.argv[1]
man = json.load(open('Arme/manifest.json', encoding='utf-8'))
if any(i.get('arquivo') == f for i in man.get('itens', [])):
    sys.exit(0)
sys.exit(1)
PY
  then
    echo "ERRO: novo arquivo sem entrada no manifesto: $file" >&2
    missing=1
  fi
done <<< "$added_files"

[[ "$missing" -eq 0 ]] || exit 5
echo "OK: novos arquivos de staging em Arme/Add/ estao classificados no manifesto"
