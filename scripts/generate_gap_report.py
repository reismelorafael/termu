#!/usr/bin/env python3
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
TRUTH = ROOT / "docs" / "RUNTIME_TRUTH_TABLE.md"
OUT = ROOT / "reports" / "operational_gap_report.md"
CATEGORIES = ["PROVADO", "PARCIAL", "TOKEN_VAZIO", "RISCO", "PRÓXIMO PASSO"]

def rows():
    for line in TRUTH.read_text(encoding="utf-8").splitlines():
        if not line.startswith("|") or line.startswith("|---") or "Recurso" in line:
            continue
        parts = [p.strip() for p in line.strip("|").split("|")]
        if len(parts) >= 4:
            yield parts[:4]

def main() -> int:
    OUT.parent.mkdir(parents=True, exist_ok=True)
    buckets = {k: [] for k in CATEGORIES}
    for recurso, estado, evidencia, lacuna in rows():
        item = f"- **{recurso}** — estado: `{estado}`; evidência: {evidencia}; lacuna: {lacuna}"
        if "TOKEN_VAZIO" in estado:
            buckets["TOKEN_VAZIO"].append(item)
        elif "PROVADO" in estado:
            buckets["PROVADO"].append(item)
        elif "PARCIAL" in estado:
            buckets["PARCIAL"].append(item)
        if lacuna and lacuna != "—":
            buckets["PRÓXIMO PASSO"].append(f"- **{recurso}** — {lacuna}")
        if re.search(r"backend real|device|certificados|resolver|proot\.real", lacuna, re.I):
            buckets["RISCO"].append(f"- **{recurso}** — risco operacional: {lacuna}")
    text = ["# Operational Gap Report", "", "Gerado a partir de `docs/RUNTIME_TRUTH_TABLE.md`.", ""]
    for cat in CATEGORIES:
        text += [f"## {cat}", ""]
        text += buckets[cat] or ["- Nenhum item."]
        text.append("")
    OUT.write_text("\n".join(text), encoding="utf-8")
    print(OUT)
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
