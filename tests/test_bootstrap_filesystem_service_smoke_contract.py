from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def test_smoke_script_exercises_bootstrap_filesystem_and_service_paths() -> None:
    script = (ROOT / "scripts/smoke_bootstrap_filesystem_proot_busybox_service.sh").read_text(
        encoding="utf-8"
    )

    for token in [
        "${PREFIX}/bin/sh",
        "${PREFIX}/bin/pkg",
        "${PREFIX}/bin/apkmanager",
        "${PREFIX}/bin/shellbash",
        "${PREFIX}/bin/busybox-safe",
        "${PREFIX}/bin/proot-safe",
        "${HOME_DIR}/storage",
        "am startservice",
        "com.termux.rafacodephi/com.termux.app.TermuxService",
        "com.termux.rafacodephi.service_execute",
        "com.termux.rafacodephi.file://",
        "com.termux.rafacodephi.execute.runner",
        "app-shell",
        "service-executed.ok",
        "rafcodephi_smoke=PASS",
        "claim_boundary=runtime_smoke_only_no_performance_claim",
    ]:
        assert token in script


def test_optional_busybox_proot_payload_absence_is_classified_not_hidden() -> None:
    script = (ROOT / "scripts/smoke_bootstrap_filesystem_proot_busybox_service.sh").read_text(
        encoding="utf-8"
    )

    assert "TOKEN_VAZIO_OPTIONAL_BINARY: busybox-safe wrapper present but real busybox absent" in script
    assert "TOKEN_VAZIO_OPTIONAL_BINARY: proot-safe wrapper present but real proot absent" in script
    assert "[ \"$rc\" -eq 127 ]" in script


def test_service_execution_guard_doc_preserves_claim_boundary() -> None:
    doc = (ROOT / "docs/audits/BOOTSTRAP_FILESYSTEM_PROOT_BUSYBOX_SERVICE_EXECUTION_GUARD.md").read_text(
        encoding="utf-8"
    )

    for token in [
        "BOOTSTRAP_FILESYSTEM_SMOKE_SCRIPT = PRESENT",
        "SERVICE_EXECUTION_MARKER = REQUIRED",
        "BUSYBOX_PROOT_WRAPPERS = REQUIRED",
        "REAL_BUSYBOX_PROOT_PAYLOADS = OPTIONAL_BUT_CLASSIFIED",
        "PERFORMANCE_CLAIMS = BLOCKED_UNTIL_MEASURED",
        "DEVICE_RUNTIME_PROOF = REQUIRES_RUNNING_SCRIPT_ON_DEVICE",
        "NEON/SIMD speedup",
        "filesystem throughput gain",
        "root success",
    ]:
        assert token in doc


def test_validator_tracks_installer_and_service_execution_contract() -> None:
    validator = (ROOT / "tools/validate_bootstrap_filesystem_service_smoke_contract.py").read_text(
        encoding="utf-8"
    )

    for token in [
        "SCRIPT_TOKENS",
        "SERVICE_TOKENS",
        "INSTALLER_TOKENS",
        "ACTION_SERVICE_EXECUTE",
        "AppShell.execute",
        "TermuxSession.execute",
        "verifyRuntimeBinary(TERMUX_STAGING_PREFIX_DIR_PATH + \\\"/bin/busybox\\\", \\\"busybox\\\")",
        "BootstrapBaremetalGuard.validateAfterBootstrap(TERMUX_PREFIX_DIR_PATH)",
        "device_runtime=requires_running_smoke_script_on_device",
    ]:
        assert token in validator
