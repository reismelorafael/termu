#!/usr/bin/env python3
"""Non-fatal Android boot hotfix compatibility hook.

The beta APK matrix must not depend on fragile source-text rewriting at build
runtime. Source contracts are enforced by committed code and tests; this hook is
kept as an operational checkpoint so older workflow wiring remains compatible.
"""

from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def check_file(path: str, label: str) -> None:
    candidate = ROOT / path
    if candidate.exists():
        print(f"[boot-hotfix] {label}: present")
    else:
        print(f"[boot-hotfix][WARN] {label}: missing at {candidate}")


def main() -> int:
    print("[boot-hotfix] source rewrite disabled; using committed compatibility contracts")
    check_file("gradle.properties", "gradle runtime sdk contract")
    check_file("tests/test_android_exec_runtime_contract.py", "android executable prefix contract test")
    check_file("scripts/termux_prefix_exec_compat_hotfix.sh", "termux prefix compatibility helper")
    print("[boot-hotfix] complete")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
