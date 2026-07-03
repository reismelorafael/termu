#!/usr/bin/env python3
"""Validate the benchmark/wizard/filesystem operational contract.

This validator is intentionally structural. It does not run Android, install APKs,
execute filesystem benchmarks, measure NEON/SIMD speedups, or promote runtime
claims. It checks that the repository keeps the benchmark, wizard, filesystem and
claim-boundary terms wired together.

Exit codes:
  0 = structural contract is present
  1 = structural contract is incomplete
"""

from __future__ import annotations

from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]

CONTRACT = ROOT / "docs/audits/BENCHMARK_WIZARD_FILESYSTEM_OPERATIONAL_EXCELLENCE.md"
FLORENCE = ROOT / "docs/audits/FLORENCE_FILESYSTEM_HARDWARE_DIAGNOSTIC.md"
INSTALL_WIZARD = ROOT / "docs/audits/INSTALL_WIZARD_PACKAGE_BOOTSTRAP_RUNTIME_GUARD.md"
BETA_VALIDATOR = ROOT / "tools/validate_beta_artifact_bundle_contract.py"
GRADLE_PROPERTIES = ROOT / "gradle.properties"
APP_BUILD = ROOT / "app/build.gradle"

REQUIRED_CONTRACT_TOKENS = (
    "BENCHMARK_CONTRACT = GUARDED",
    "WIZARD_READINESS_CONTRACT = GUARDED",
    "FILESYSTEM_DIFFERENTIAL = CLAIM_BOUNDED_OPERATIONAL_LAYER",
    "PERFORMANCE_CLAIMS = BLOCKED_UNTIL_MEASURED",
    "BOOTSTRAP_INSTALL_TIME",
    "FIRST_SESSION_START_TIME",
    "FILESYSTEM_SCAN_THROUGHPUT",
    "NATIVE_FALLBACK_EQUIVALENCE",
    "$PREFIX/bin/sh",
    "$PREFIX/bin/pkg",
    "$PREFIX/bin/apkmanager",
    "$PREFIX/bin/shellbash",
    "$PREFIX/bin/busybox-safe",
    "$PREFIX/bin/proot-safe",
    "$HOME/storage",
    "capability detection",
    "scalar/fallback path",
    "deterministic equivalence test",
    "rollback/failback behavior",
    "claim boundary",
)

REQUIRED_FLORENCE_TOKENS = (
    "claim_limited",
    "fixed 4096-byte blocks",
    "zero malloc",
    "inline CRC32C",
    "device smoke tests before runtime claims",
    "NEON/SIMD performance claims",
    "filesystem throughput claims",
)

REQUIRED_INSTALL_WIZARD_TOKENS = (
    "install_wizard_guard",
    "WRITE_PERMISSION_CALLBACK = INSTALL_WIZARD_GATE",
    "STORAGE_SYMLINKS_AFTER_PERMISSION = REQUIRED",
    "BOOTSTRAP_INSTALL_AFTER_PERMISSION = REQUIRED_VIA_SERVICE_BIND",
    "PKG_INSTALL_INTERFACE = REQUIRED",
    "REAL_BUSYBOX_BINARY = OPTIONAL_BOOTSTRAP_PAYLOAD",
    "DEVICE_RUNTIME_PROOF = STILL_REQUIRES_DEVICE_SMOKE",
)

REQUIRED_BETA_VALIDATOR_TOKENS = (
    "claim_boundary=structural_artifact_validation_only",
    "REQUIRED_ABIS = (\"armeabi-v7a\", \"arm64-v8a\", \"x86_64\")",
    "validate_sha256s",
    "TOKEN_VAZIO_INPUT",
)

REQUIRED_ABI_TOKENS = (
    "termux.abi.matrix=armeabi-v7a,arm64-v8a",
    "termux.abi.optional=",
    "termux.abi.universal=true",
)

REQUIRED_APP_BUILD_TOKENS = (
    "com.termux.rafacodephi",
    "BOOTSTRAP_BAREMETAL_STRICT",
    "SUPPORTED_APK_ABIS",
    "max-page-size=16384",
)


def read_text(path: Path, errors: list[str]) -> str:
    if not path.exists():
        errors.append(f"missing file: {path.relative_to(ROOT)}")
        return ""
    return path.read_text(encoding="utf-8")


def require_tokens(name: str, text: str, tokens: tuple[str, ...], errors: list[str]) -> None:
    for token in tokens:
        if token not in text:
            errors.append(f"{name}: missing token: {token}")


def validate() -> list[str]:
    errors: list[str] = []

    contract = read_text(CONTRACT, errors)
    florence = read_text(FLORENCE, errors)
    install_wizard = read_text(INSTALL_WIZARD, errors)
    beta_validator = read_text(BETA_VALIDATOR, errors)
    gradle_properties = read_text(GRADLE_PROPERTIES, errors)
    app_build = read_text(APP_BUILD, errors)

    require_tokens("contract", contract, REQUIRED_CONTRACT_TOKENS, errors)
    require_tokens("florence", florence, REQUIRED_FLORENCE_TOKENS, errors)
    require_tokens("install_wizard", install_wizard, REQUIRED_INSTALL_WIZARD_TOKENS, errors)
    require_tokens("beta_validator", beta_validator, REQUIRED_BETA_VALIDATOR_TOKENS, errors)
    require_tokens("gradle_properties", gradle_properties, REQUIRED_ABI_TOKENS, errors)
    require_tokens("app_build", app_build, REQUIRED_APP_BUILD_TOKENS, errors)

    return errors


def main() -> int:
    errors = validate()
    if errors:
        print("benchmark_wizard_filesystem_contract=FAIL")
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        return 1
    print("benchmark_wizard_filesystem_contract=PASS")
    print("claim_boundary=structural_contract_only")
    print("performance_claims=blocked_until_measured")
    print("device_runtime=still_requires_device_smoke")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
