from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MARKER = ROOT / "docs/audits/PKG_REAL_NEXT_PR_MARKER.md"


def test_pkg_real_follow_up_marker_keeps_scope_clear() -> None:
    text = MARKER.read_text(encoding="utf-8")
    assert "PR anterior" in text
    assert "PR atual" in text
    assert "DEVICE_REAL_PKG_VALIDATED" in text
