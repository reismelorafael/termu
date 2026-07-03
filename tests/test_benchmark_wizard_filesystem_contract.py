from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def test_benchmark_wizard_filesystem_contract_declares_required_boundaries() -> None:
    text = (ROOT / "docs/audits/BENCHMARK_WIZARD_FILESYSTEM_OPERATIONAL_EXCELLENCE.md").read_text(
        encoding="utf-8"
    )

    required = [
        "BENCHMARK_CONTRACT = GUARDED",
        "WIZARD_READINESS_CONTRACT = GUARDED",
        "FILESYSTEM_DIFFERENTIAL = CLAIM_BOUNDED_OPERATIONAL_LAYER",
        "METRICS_COHERENCE = REQUIRED",
        "DEVICE_RUNTIME_PROOF = STILL_REQUIRES_DEVICE_SMOKE",
        "PERFORMANCE_CLAIMS = BLOCKED_UNTIL_MEASURED",
        "benchmark_id",
        "repo_commit",
        "metric_unit",
        "baseline",
        "claim_boundary",
    ]

    for token in required:
        assert token in text


def test_wizard_filesystem_targets_are_explicit() -> None:
    text = (ROOT / "docs/audits/BENCHMARK_WIZARD_FILESYSTEM_OPERATIONAL_EXCELLENCE.md").read_text(
        encoding="utf-8"
    )

    for token in [
        "$PREFIX/bin/sh",
        "$PREFIX/bin/pkg",
        "$PREFIX/bin/apkmanager",
        "$PREFIX/bin/shellbash",
        "$PREFIX/bin/busybox-safe",
        "$PREFIX/bin/proot-safe",
        "$HOME/storage",
    ]:
        assert token in text


def test_operational_excellence_gate_blocks_slogan_optimization() -> None:
    text = (ROOT / "docs/audits/BENCHMARK_WIZARD_FILESYSTEM_OPERATIONAL_EXCELLENCE.md").read_text(
        encoding="utf-8"
    )

    gate_order = [
        "capability detection",
        "fast path",
        "scalar/fallback path",
        "deterministic equivalence test",
        "bounds and buffer check",
        "non-destructive failure behavior",
        "rollback/failback behavior",
        "artifact/log output",
        "metric emission",
        "claim boundary",
    ]

    positions = [text.index(token) for token in gate_order]
    assert positions == sorted(positions)


def test_validator_is_structural_and_claim_bounded() -> None:
    validator = (ROOT / "tools/validate_benchmark_wizard_filesystem_contract.py").read_text(
        encoding="utf-8"
    )

    for token in [
        "structural",
        "does not run Android",
        "does not run Android, install APKs",
        "performance_claims=blocked_until_measured",
        "device_runtime=still_requires_device_smoke",
        "REQUIRED_CONTRACT_TOKENS",
        "REQUIRED_INSTALL_WIZARD_TOKENS",
        "REQUIRED_ABI_TOKENS",
    ]:
        assert token in validator
