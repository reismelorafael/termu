from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DOC = ROOT / "docs/audits/REAL_PKG_PROMOTION_CONTRACT.md"
SCRIPT = ROOT / "scripts/device_pkg_smoke.sh"


def test_real_pkg_promotion_doc_has_the_three_states() -> None:
    text = DOC.read_text(encoding="utf-8")

    for token in (
        "pkg help",
        "pkg bridge",
        "pkg real",
        "DEVICE_MINIMAL_PKG_LAYER_VALIDATED",
        "DEVICE_REAL_PKG_VALIDATED",
    ):
        assert token in text


def test_real_pkg_promotion_doc_lists_required_core_payload() -> None:
    text = DOC.read_text(encoding="utf-8")

    for token in (
        "apt",
        "apt-get",
        "dpkg",
        "libapt",
        "bash",
        "busybox",
        "termux-tools",
        "ca-certificates",
        "sources.list",
        "resolv.conf",
    ):
        assert token in text


def test_real_pkg_promotion_doc_matches_device_smoke_commands() -> None:
    doc = DOC.read_text(encoding="utf-8")
    script = SCRIPT.read_text(encoding="utf-8")

    for token in (
        "REQUIRE_REAL_PKG=true",
        "pkg update -y",
        "pkg install -y nano",
        "nano --version",
        "pkg install -y python",
        "python --version",
        "pkg install -y git",
        "git --version",
    ):
        assert token in doc
        assert token.replace("REQUIRE_REAL_PKG=true", "REQUIRE_REAL_PKG") in script
