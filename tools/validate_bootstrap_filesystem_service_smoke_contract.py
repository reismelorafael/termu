#!/usr/bin/env python3
"""Validate the bootstrap/filesystem/proot/busybox/service smoke contract.

This validator is structural. It does not run Android, start TermuxService, or
claim device runtime. It ensures the repository contains a real-device smoke
script that exercises the required paths and keeps claim boundaries explicit.
"""

from __future__ import annotations

from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / "scripts/smoke_bootstrap_filesystem_proot_busybox_service.sh"
DOC = ROOT / "docs/audits/BOOTSTRAP_FILESYSTEM_PROOT_BUSYBOX_SERVICE_EXECUTION_GUARD.md"
SERVICE = ROOT / "app/src/main/java/com/termux/app/TermuxService.java"
INSTALLER = ROOT / "app/src/main/java/com/termux/app/TermuxInstaller.java"

SCRIPT_TOKENS = (
    "${PREFIX}/bin/sh",
    "${PREFIX}/bin/pkg",
    "${PREFIX}/bin/apkmanager",
    "${PREFIX}/bin/shellbash",
    "${PREFIX}/bin/busybox-safe",
    "${PREFIX}/bin/proot-safe",
    "${HOME_DIR}/storage",
    "am startservice",
    'APP_ID="${RAF_APP_ID:-com.termux.rafacodephi}"',
    'SERVICE_CLASS="${RAF_SERVICE_CLASS:-${APP_ID}/com.termux.app.TermuxService}"',
    'SERVICE_ACTION="${RAF_SERVICE_ACTION:-${APP_ID}.service_execute}"',
    'SERVICE_FILE_SCHEME="${RAF_SERVICE_FILE_SCHEME:-${APP_ID}.file}"',
    'EXTRA_RUNNER="${RAF_EXTRA_RUNNER:-${APP_ID}.execute.runner}"',
    "app-shell",
    "service-executed.ok",
    "rafcodephi_smoke=PASS",
    "claim_boundary=runtime_smoke_only_no_performance_claim",
    "TOKEN_VAZIO_OPTIONAL_BINARY",
)

DOC_TOKENS = (
    "BOOTSTRAP_FILESYSTEM_SMOKE_SCRIPT = PRESENT",
    "SERVICE_EXECUTION_MARKER = REQUIRED",
    "BUSYBOX_PROOT_WRAPPERS = REQUIRED",
    "REAL_BUSYBOX_PROOT_PAYLOADS = OPTIONAL_BUT_CLASSIFIED",
    "PERFORMANCE_CLAIMS = BLOCKED_UNTIL_MEASURED",
    "DEVICE_RUNTIME_PROOF = REQUIRES_RUNNING_SCRIPT_ON_DEVICE",
)

SERVICE_TOKENS = (
    "ACTION_SERVICE_EXECUTE",
    "actionServiceExecute",
    "executeTermuxTaskCommand",
    "executeTermuxSessionCommand",
    "createTermuxTask",
    "createTermuxSession",
    "AppShell.execute",
    "TermuxSession.execute",
)

INSTALLER_TOKENS = (
    "verifyRuntimeBinary(TERMUX_STAGING_PREFIX_DIR_PATH + \"/bin/sh\", \"sh\")",
    "verifyRuntimeBinary(TERMUX_STAGING_PREFIX_DIR_PATH + \"/bin/busybox\", \"busybox\")",
    "verifyRuntimeBinary(TERMUX_STAGING_PREFIX_DIR_PATH + \"/bin/proot\", \"proot\")",
    "BootstrapBaremetalGuard.validateAfterBootstrap(TERMUX_PREFIX_DIR_PATH)",
    "rollbackFailedBootstrapInstall",
)


def read(path: Path, errors: list[str]) -> str:
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
    script = read(SCRIPT, errors)
    doc = read(DOC, errors)
    service = read(SERVICE, errors)
    installer = read(INSTALLER, errors)

    require_tokens("script", script, SCRIPT_TOKENS, errors)
    require_tokens("doc", doc, DOC_TOKENS, errors)
    require_tokens("service", service, SERVICE_TOKENS, errors)
    require_tokens("installer", installer, INSTALLER_TOKENS, errors)

    if "NEON speedup" in doc and "blocked" not in doc.lower():
        errors.append("doc: performance language must stay blocked/claim-limited")

    return errors


def main() -> int:
    errors = validate()
    if errors:
        print("bootstrap_filesystem_service_smoke_contract=FAIL")
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        return 1
    print("bootstrap_filesystem_service_smoke_contract=PASS")
    print("claim_boundary=structural_validator_only")
    print("device_runtime=requires_running_smoke_script_on_device")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
