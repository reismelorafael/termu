from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / "scripts/audit_operational_stubs.py"


def test_operational_stub_audit_documents_depth_five_and_structural_boundary() -> None:
    text = SCRIPT.read_text(encoding="utf-8")
    for token in [
        "default: five levels",
        "--max-depth",
        "REPORT_MD",
        "REPORT_JSON",
        "structural repository scan only; no runtime proof claimed",
        "falsification",
        "stub_or_placeholder",
        "failsafe_failover_rollback",
    ]:
        assert token in text


def test_operational_stub_audit_keeps_vectra_known_risks_visible() -> None:
    text = SCRIPT.read_text(encoding="utf-8")
    for token in ["VOID paradox", "attractor_table", "period-42", "BitOmega"]:
        assert token in text
