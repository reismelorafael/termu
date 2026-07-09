from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def test_readme_runtime_claim_boundary_doc_blocks_overclaim() -> None:
    boundary = (ROOT / "docs/audits/README_RUNTIME_CLAIM_BOUNDARY_HOTFIX.md").read_text(
        encoding="utf-8"
    )

    for token in [
        "documentation_hotfix / runtime_claim_boundary / no_device_claim",
        "fully compatible",
        "will NOT crash",
        "NEON/SIMD optimized",
        "DEVICE_RUNTIME = PENDING_REAL_DEVICE_SMOKE",
        "PERFORMANCE_CLAIMS = BLOCKED_UNTIL_MEASURED",
        "runtime compatibility is proven",
        "measured speedup",
        "ARM32 runtime is validated",
    ]:
        assert token in boundary


def test_readme_runtime_claim_validator_is_structural_only() -> None:
    validator = (ROOT / "tools/validate_readme_runtime_claim_boundary.py").read_text(
        encoding="utf-8"
    )

    for token in [
        "readme_runtime_claim_boundary=PASS",
        "claim_boundary=readme_wording_does_not_equal_device_runtime_proof",
        "device_runtime=still_requires_real_device_smoke",
        "performance_claims=blocked_until_measured",
        "Structural only",
        "does not run Android",
        "benchmark NEON/SIMD",
    ]:
        assert token in validator


def test_readme_risk_terms_are_bound_to_smoke_evidence_path() -> None:
    validator = (ROOT / "tools/validate_readme_runtime_claim_boundary.py").read_text(
        encoding="utf-8"
    )

    for token in [
        "RISK_TERMS",
        "fully compatible",
        "will NOT crash",
        "NEON/SIMD optimized",
        "BOOTSTRAP_FS_SERVICE_SMOKE=PASS",
        "TOKEN_VAZIO_OPTIONAL_BINARY",
        "am startservice",
    ]:
        assert token in validator
