from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
BUILDER = ROOT / 'scripts/build_real_arm_bootstrap_core.py'
VALIDATOR = ROOT / 'scripts/validate_real_arm_bootstrap_core.py'
BRIDGE = ROOT / 'scripts/rafcodephi_packages_bridge.sh'
RUNBOOK = ROOT / 'docs/ENGINEERING_RUNBOOK_RAFCODEPHI.md'

def test_real_arm_core_builder_declares_required_payload_and_arches():
    text = BUILDER.read_text(encoding='utf-8')
    for token in [
        'CORE_PACKAGES', '"apt"', '"bash"', '"busybox"', '"ca-certificates"',
        '"dpkg"', '"proot"', '"termux-tools"', 'ARCHES = ("aarch64", "arm")',
        'BOOTSTRAP_REAL_APT_READY=1', 'BOOTSTRAP_REAL_DPKG_READY=1',
        'BOOTSTRAP_REAL_PROOT_READY=1', 'BOOTSTRAP_CA_CERTIFICATES_READY=1',
        'BOOTSTRAP_DNS_RESOLVER_READY=1', 'proot.real', 'sources.list', 'resolv.conf'
    ]:
        assert token in text

def test_real_arm_core_builder_verifies_hashes_and_rewrites_prefix():
    text = BUILDER.read_text(encoding='utf-8')
    for token in ['verify_sha256', 'hashlib.sha256', 'dependency_closure', 'parse_depends', 'replace("/data/data/com.termux/files/usr"', 'SYMLINKS.txt']:
        assert token in text

def test_real_arm_core_validator_blocks_missing_runtime_contract():
    text = VALIDATOR.read_text(encoding='utf-8')
    for token in ['bin/apt', 'bin/apt-get', 'bin/dpkg', 'bin/proot.real', 'etc/apt/sources.list', 'etc/resolv.conf', 'unsafe zip entry', 'legacy prefix']:
        assert token in text

def test_bridge_now_targets_arm_core_only_and_ca_certificates():
    text = BRIDGE.read_text(encoding='utf-8')
    assert 'REQUIRED_PACKAGES=(apt bash busybox proot dpkg ca-certificates coreutils termux-tools)' in text
    assert 'REQUIRED_ARCHES=(aarch64 arm)' in text

def test_runbook_requires_pkg_install_promotion_sequence():
    text = RUNBOOK.read_text(encoding='utf-8')
    for token in ['build_real_arm_bootstrap_core.py --arch all', 'validate_real_arm_bootstrap_core.py', 'DEVICE_SMOKE_REQUIRED=true', 'pkg update', 'pkg install nano', 'pkg install python', 'pkg install git']:
        assert token in text
