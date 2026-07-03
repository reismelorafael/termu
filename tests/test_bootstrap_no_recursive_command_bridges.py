from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GENERATOR = ROOT / "scripts/build_rafaelia_bootstraps.sh"


def test_pkg_apt_bridge_does_not_recurse():
    source = GENERATOR.read_text(encoding="utf-8")
    assert "is_raf_wrapper" in source
    assert "RAFCODEPHI apt bridge" in source
    assert "RAFCODEPHI apt-get bridge" in source
    assert "RAFCODEPHI developer bootstrap pkg" not in source
    assert "RAFCODEPHI bootstrap busybox stub" not in source
    assert "RAFCODEPHI bootstrap proot stub" not in source

    # pkg must delegate to a real apt/apt-get backend, never exec itself.
    pkg_start = source.index('cat > "${generated_root}/bin/pkg" <<')
    pkg_end = source.index("\nEOS\n", pkg_start)
    pkg_block = source[pkg_start:pkg_end]
    assert 'exec "${PREFIX}/bin/pkg"' not in pkg_block

    # apkmanager legitimately bridges to the distinct pkg binary; that is not
    # self-recursion and must keep working.
    apkmanager_start = source.index('cat > "${generated_root}/bin/apkmanager" <<')
    apkmanager_end = source.index("\nEOS\n", apkmanager_start)
    apkmanager_block = source[apkmanager_start:apkmanager_end]
    assert 'exec "${prefix}/bin/pkg" "\\$@"' in apkmanager_block
