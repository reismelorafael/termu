#!/usr/bin/env python3
"""Validate the terminal-service bootstrap boundary record.

This is a structural/audit validator. It does not build the Android app, does not
run device runtime, and does not claim that the service-level Java guard is already
implemented. It exists to keep the remaining gap explicit until a safe partial code
patch can land.
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
    ]:
        require(service, token, "service execution path")

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
        "SERVICE_PLUGIN_EXECUTION_BOOTSTRAP_GUARD = TOKEN_VAZIO_CODE_PATCH",
        "NORMAL_ACTIVITY_FIRST_SESSION = GUARDED",
        "FAILSAFE_SESSION_COMPATIBILITY = MUST_PRESERVE",
        "DEVICE_RUNTIME_SMOKE = PENDING",
    ]:
        require(doc, token, "documented boundary")

    print("[terminal-service-gap] PASS: normal startup is guarded; service execution guard gap remains explicit")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
