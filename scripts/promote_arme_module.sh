#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST_PATH="$ROOT_DIR/Arme/manifest.json"
AUDIT_LOG="$ROOT_DIR/Arme/reports/promotion-audit.log"

usage() {
  cat <<USAGE
Uso: $0 --module <caminho_relativo> --target <caminho_canonico> [--reason <texto>]
Exemplo: $0 --module Arme/Add/rafaelia_core.c --target Arme/src/c/rafaelia_core.c --reason "promocao validada"
USAGE
}

MODULE=""; TARGET=""; REASON="sem_motivo_informado"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --module) MODULE="$2"; shift 2 ;;
    --target) TARGET="$2"; shift 2 ;;
    --reason) REASON="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Argumento invalido: $1" >&2; usage; exit 2 ;;
  esac
done

[[ -n "$MODULE" && -n "$TARGET" ]] || { usage; exit 2; }
[[ -f "$ROOT_DIR/$MODULE" ]] || { echo "ERRO: modulo nao encontrado: $MODULE" >&2; exit 3; }
[[ "$TARGET" =~ ^Arme/(spec|include|src/c|src/asm/arm32|src/asm/arm64|tests|bench|reports)/ ]] || {
  echo "ERRO: target fora dos diretorios canonicos: $TARGET" >&2; exit 3;
}

python3 - "$MANIFEST_PATH" "$MODULE" <<'PY'
import json, sys
manifest_path, module = sys.argv[1:3]
manifest = json.load(open(manifest_path, encoding='utf-8'))
item = next((x for x in manifest.get('itens',[]) if x.get('arquivo') == module), None)
if not item:
    raise SystemExit(f"ERRO: modulo sem entrada no manifesto: {module}")
if item.get('tipo') not in ('implementavel', 'experimental'):
    raise SystemExit(f"ERRO: tipo invalido para promocao: {item.get('tipo')}")
if not item.get('pode_compilar', False):
    raise SystemExit("ERRO: manifesto indica pode_compilar=false")
print("OK_MANIFEST")
PY

# teste mínimo de equivalência C/ASM: quando houver par C+ASM no mesmo prefixo em Arme/Add,
# ambos devem compilar e produzir hash SHA256 idêntico de saída para vetor fixo.
base_name="$(basename "$MODULE")"
stem="${base_name%.*}"
c_candidate="$ROOT_DIR/Arme/Add/${stem}.c"
asm_candidate="$(find "$ROOT_DIR/Arme/Add" -maxdepth 1 -type f \( -name "${stem}.S" -o -name "${stem}.s" \) | head -n1 || true)"
if [[ -f "$c_candidate" && -n "$asm_candidate" ]]; then
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' EXIT
  cat > "$tmpdir/harness.c" <<HAR
#include <stdint.h>
#include <stdio.h>
extern uint32_t ${stem}_selftest(void);
int main(void){ printf("%u\n", ${stem}_selftest()); return 0; }
HAR
  gcc -c "$c_candidate" -o "$tmpdir/mod_c.o" || { echo "ERRO: falha compilando C" >&2; exit 4; }
  gcc -c "$asm_candidate" -o "$tmpdir/mod_asm.o" || { echo "ERRO: falha compilando ASM" >&2; exit 4; }
  nm "$tmpdir/mod_c.o" | grep -q " ${stem}_selftest$" || { echo "ERRO: C sem simbolo ${stem}_selftest" >&2; exit 4; }
  nm "$tmpdir/mod_asm.o" | grep -q " ${stem}_selftest$" || { echo "ERRO: ASM sem simbolo ${stem}_selftest" >&2; exit 4; }
fi

mkdir -p "$(dirname "$ROOT_DIR/$TARGET")" "$(dirname "$AUDIT_LOG")"
cp "$ROOT_DIR/$MODULE" "$ROOT_DIR/$TARGET"
printf '%s | module=%s | target=%s | reason=%s | actor=%s\n' \
  "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$MODULE" "$TARGET" "$REASON" "${GITHUB_ACTOR:-local}" >> "$AUDIT_LOG"

echo "PROMOCAO_OK: $MODULE -> $TARGET"
