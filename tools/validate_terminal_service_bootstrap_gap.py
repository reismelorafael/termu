#!/usr/bin/env python3
"""Validate the terminal-service bootstrap boundary record.

This is a structural/audit validator. It does not build the Android app and does
not run device runtime. It confirms that the service-level Java guard
(`ensureBootstrapReadyForExecution`) is wired in before `AppShell.execute(...)`
and `TermuxSession.execute(...)`, while the device-runtime smoke proof remains
explicitly pending until it is actually run on a device.
"""
from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SERVICE = ROOT / "app/src/main/java/com/termux/app/TermuxService.java"
ACTIVITY = ROOT / "app/src/main/java/com/termux/app/TermuxActivity.java"
DOC = ROOT / "docs/audits/TERMINAL_SERVICE_BOOTSTRAP_GAP.md"


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def require(text: str, token: str, label: str) -> None:
    if token not in text:
        raise SystemExit(f"[terminal-service-gap] missing {label}: {token}")


def main() -> int:
    service = read(SERVICE)
    activity = read(ACTIVITY)
    doc = read(DOC)

    for token in [
        "ACTION_SERVICE_EXECUTE",
        "actionServiceExecute",
        "executeTermuxTaskCommand",
        "executeTermuxSessionCommand",
        "createTermuxTask",
        "createTermuxSession",
        "AppShell.execute",
        "TermuxSession.execute",
        "ensureBootstrapReadyForExecution",
        "failExecutionCommandOnBootstrapNotReady",
        "TermuxQualityManager.checkBootstrapComplete()",
    ]:
        require(service, token, "service execution path")

    # The guard must run before the executor call at each call site, not merely
    # exist somewhere in the file.
    task_guard_index = service.index("ensureBootstrapReadyForExecution(executionCommand, \"TermuxTask\")")
    task_exec_index = service.index("AppShell.execute(")
    if not task_guard_index < task_exec_index:
        raise SystemExit("[terminal-service-gap] ensureBootstrapReadyForExecution must run before AppShell.execute(...)")

    session_guard_index = service.index("ensureBootstrapReadyForExecution(executionCommand, \"TermuxSession\")")
    session_exec_index = service.index("TermuxSession.execute(")
    if not session_guard_index < session_exec_index:
        raise SystemExit("[terminal-service-gap] ensureBootstrapReadyForExecution must run before TermuxSession.execute(...)")

    for token in [
        "ensureStorageAccessOrRequest",
        "requestStoragePermission(true)",
        "TermuxInstaller.setupStorageSymlinks",
        "startAndBindTermuxServiceOrFail()",
        "TermuxInstaller.setupBootstrapIfNeeded",
        "createInitialSession(intent)",
    ]:
        require(activity, token, "activity startup guard")

    for token in [
        "SERVICE_PLUGIN_EXECUTION_BOOTSTRAP_GUARD = IMPLEMENTED",
        "NORMAL_ACTIVITY_FIRST_SESSION = GUARDED",
        "FAILSAFE_SESSION_COMPATIBILITY = MUST_PRESERVE",
        "DEVICE_RUNTIME_SMOKE = PENDING",
    ]:
        require(doc, token, "documented boundary")

    print("[terminal-service-gap] PASS: normal startup is guarded; service/plugin execution now gated by ensureBootstrapReadyForExecution; device-runtime smoke remains explicitly pending")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
