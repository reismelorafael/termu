import hashlib
import importlib.util
import zipfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
VALIDATOR_PATH = ROOT / "tools" / "validate_beta_artifact_bundle_contract.py"


def load_validator():
    spec = importlib.util.spec_from_file_location("validate_beta_artifact_bundle_contract", VALIDATOR_PATH)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def add_required_bundle_entries(zf: zipfile.ZipFile, checksum_override: dict[str, str] | None = None) -> None:
    checksum_override = checksum_override or {}
    text_files = {
        "dist/apk-matrix/ARTIFACT_MANIFEST.txt": "artifact_dir=test\n",
        "dist/apk-matrix/APK_SIZE_REPORT.tsv": "apk\ttype\tabi\tsize_bytes\n",
        "dist/apk-matrix/APK_SIZE_DIFF_RELEASE.tsv": "abi\tunsigned_apk\tunsigned_size_bytes\tsigned_apk\tsigned_size_bytes\tdelta_bytes\n",
        "docs/BETA_BUILD_REPORT.md": "CI remote = READY\n",
        "docs/BETA_READINESS_REPORT.md": "BOOTSTRAP_BUILD_READY: YES\n",
        "docs/BETA_BOOTSTRAP_BAREMETAL_GUARD.md": "guard\n",
        "docs/BETA_BOOTSTRAP_BAREMETAL_STATUS.md": "BOOTSTRAP_BAREMETAL_RUNTIME_VALIDATED = NO\n",
        "out/bootstrap_baremetal_guard_smoke.txt": "selftest_rc=0\n",
        "out/pss3_failure_report.txt": "failure_trace.csv absent; skipping PSS3 audit\n",
    }
    for name, text in text_files.items():
        zf.writestr(name, text)

    apk_paths = [
        "unsigned/termux-rafcodephi-release-armeabi-v7a.apk",
        "unsigned/termux-rafcodephi-release-arm64-v8a.apk",
        "unsigned/termux-rafcodephi-release-x86_64.apk",
        "unsigned/termux-rafcodephi-release-universal.apk",
        "signed/termux-rafcodephi-release-armeabi-v7a-signed.apk",
        "signed/termux-rafcodephi-release-arm64-v8a-signed.apk",
        "signed/termux-rafcodephi-release-x86_64-signed.apk",
        "signed/termux-rafcodephi-release-universal-signed.apk",
    ]
    checksums = []
    for rel in apk_paths:
        data = ("apk:" + rel).encode("utf-8")
        zf.writestr("dist/apk-matrix/" + rel, data)
        digest = checksum_override.get(rel, sha256(data))
        checksums.append(f"{digest}  {rel}\n")
    zf.writestr("dist/apk-matrix/SHA256SUMS.txt", "".join(checksums))


def test_beta_artifact_validator_accepts_minimal_claim_bounded_bundle(tmp_path, capsys):
    validator = load_validator()
    bundle = tmp_path / "bundle.zip"
    with zipfile.ZipFile(bundle, "w") as zf:
        add_required_bundle_entries(zf)

    rc = validator.main([str(bundle)])
    output = capsys.readouterr().out

    assert rc == 0
    assert "beta_artifact_contract=PASS" in output
    assert "pss3_state=TOKEN_VAZIO_INPUT" in output
    assert "claim_boundary=structural_artifact_validation_only" in output


def test_beta_artifact_validator_rejects_checksum_mismatch(tmp_path, capsys):
    validator = load_validator()
    bundle = tmp_path / "bundle.zip"
    with zipfile.ZipFile(bundle, "w") as zf:
        add_required_bundle_entries(
            zf,
            checksum_override={
                "signed/termux-rafcodephi-release-arm64-v8a-signed.apk": "0" * 64,
            },
        )

    rc = validator.main([str(bundle)])
    captured = capsys.readouterr()

    assert rc == 1
    assert "beta_artifact_contract=FAIL" in captured.out
    assert "checksum mismatch" in captured.err
