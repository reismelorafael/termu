from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GENERATOR = ROOT / "scripts/build_rafaelia_bootstraps.sh"


def test_pkg_apt_bridge_does_not_recurse():
    source = GENERATOR.read_text(encoding="utf-8")
    assert "is_raf_wrapper" in source
    assert "RAFCODEPHI apt bridge" in source
    assert "RAFCODEPHI apt-get bridge" in source
    assert "exec \"${prefix}/bin/pkg\"" not in source
    assert "RAFCODEPHI developer bootstrap pkg" not in source
    assert "RAFCODEPHI bootstrap busybox stub" not in source
    assert "RAFCODEPHI bootstrap proot stub" not in source
