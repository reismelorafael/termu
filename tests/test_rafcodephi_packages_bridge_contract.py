from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
BRIDGE = ROOT / "scripts/rafcodephi_packages_bridge.sh"


def test_packages_bridge_points_to_rafcodephi_packages_repo():
    source = BRIDGE.read_text(encoding="utf-8")
    assert "exacordex-crypto/termux-packagesRafcodephi.git" in source
    assert "REQUIRED_PACKAGES=(apt bash busybox proot dpkg ca-certificates coreutils termux-tools)" in source
    assert "REQUIRED_ARCHES=(aarch64 arm)" in source


def test_packages_bridge_validates_required_package_recipes():
    source = BRIDGE.read_text(encoding="utf-8")
    assert "packages/${pkg}/build.sh" in source
    assert "TERMUX_PKG_VERSION" in source
    assert "workflow-dispatch-packages.txt" in source
