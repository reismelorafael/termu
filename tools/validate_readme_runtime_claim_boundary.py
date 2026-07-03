#!/usr/bin/env python3
"""Validate README runtime/performance claim boundary.

Structural only: this does not run Android, install APKs, benchmark NEON/SIMD,
or prove filesystem/runtime behavior. It prevents public README wording from
being treated as measured device evidence without a boundary record.
"""

from __future__ import annotations

from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
README = ROOT / "README.md"
BOUNDARY = ROOT / "docs/audits/README_RUNTIME_CLAIM_BOUNDARY_HOTFIX.md"
SMOKE = ROOT / "scripts/smoke_bootstrap_filesystem_proot_busybox_service.sh"

RISK_TERMS = (
    "fully compatible",
    "will NOT crash",
    "NEON/SIMD optimized",
)

REQUIRED_BOUNDARY_TOKENS = (
    "documentation_hotfix / runtime_claim_boundary / no_device_claim",
    "fully compatible",
    "will NOT crash",
    "NEON/SIMD optimized",
    "DEVICE_RUNTIME = PENDING_REAL_DEVICE_SMOKE",
    "PERFORMANCE_CLAIMS = BLOCKED_UNTIL_MEASURED",
    "repo commit",
    "APK variant",
    "device model",
    "bootstrap smoke result",
    "service smoke result",
    "claim boundary",
)

REQUIRED_SMOKE_TOKENS = (
    "BOOTSTRAP_FS_SERVICE_SMOKE=PASS",
    "TOKEN_VAZIO_OPTIONAL_BINARY",
    "am startservice",
)


def read_text(path: Path, errors: list[str]) -> str:
    if not path.exists():
        errors.append(f"missing file: {path.relative_to(ROOT)}")
        return ""
    return path.read_text(encoding="utf-8")


def require_tokens(label: str, text: str, tokens: tuple[str, ...], errors: list[str]) -> None:
    for token in tokens:
        if token not in text:
            errors.append(f"{label}: missing token: {token}")


def validate() -> list[str]:
    errors: list[str] = []
    readme = read_text(README, errors)
    boundary = read_text(BOUNDARY, errors)
    smoke = read_text(SMOKE, errors)

    risky_terms_present = [token for token in RISK_TERMS if token in readme]
    if risky_terms_present:
        require_tokens("boundary", boundary, REQUIRED_BOUNDARY_TOKENS, errors)
        require_tokens("smoke", smoke, REQUIRED_SMOKE_TOKENS, errors)
    else:
        require_tokens("boundary", boundary, (
            "DEVICE_RUNTIME = PENDING_REAL_DEVICE_SMOKE",
            "PERFORMANCE_CLAIMS = BLOCKED_UNTIL_MEASURED",
        ), errors)

    return errors


def main() -> int:
    errors = validate()
    if errors:
        print("readme_runtime_claim_boundary=FAIL")
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        return 1
    print("readme_runtime_claim_boundary=PASS")
    print("claim_boundary=readme_wording_does_not_equal_device_runtime_proof")
    print("device_runtime=still_requires_real_device_smoke")
    print("performance_claims=blocked_until_measured")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
