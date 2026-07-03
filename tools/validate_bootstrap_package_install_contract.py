#!/usr/bin/env python3
"""Validate RAFCODEPHI bootstrap package installability contract.

Structural only: this does not build the APK, does not install on Android and
does not claim device runtime. It protects the source paths that make the
bootstrap package discoverable by native incbin and installable after extraction.
"""

from __future__ import annotations

from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
BUILD_GRADLE = ROOT / "app/build.gradle"
ASM = ROOT / "app/src/main/cpp/termux-bootstrap-zip.S"
BUILDER = ROOT / "scripts/bootstrap_zip_builder.c"
BUILD_SCRIPT = ROOT / "scripts/build_rafaelia_bootstraps.sh"
INSTALLER = ROOT / "app/src/main/java/com/termux/app/TermuxInstaller.java"

REWRITTEN_ZIPS = (
    "rewritten-bootstrap-aarch64.zip",
    "rewritten-bootstrap-arm.zip",
    "rewritten-bootstrap-i686.zip",
    "rewritten-bootstrap-x86_64.zip",
)

RUNTIME_FILES = (
    "bin/sh",
    "bin/pkg",
    "bin/busybox",
    "bin/proot",
    "bin/apkmanager",
    "bin/shellbash",
    "bin/busybox-safe",
    "bin/proot-safe",
)


def read(path: Path, errors: list[str]) -> str:
    if not path.exists():
        errors.append(f"missing file: {path.relative_to(ROOT)}")
        return ""
    return path.read_text(encoding="utf-8")


def require(text: str, token: str, label: str, errors: list[str]) -> None:
    if token not in text:
        errors.append(f"{label}: missing token: {token}")


def validate() -> list[str]:
    errors: list[str] = []
    build_gradle = read(BUILD_GRADLE, errors)
    asm = read(ASM, errors)
    builder = read(BUILDER, errors)
    build_script = read(BUILD_SCRIPT, errors)
    installer = read(INSTALLER, errors)

    for zip_name in REWRITTEN_ZIPS:
        require(asm, f'.incbin "{zip_name}"', "native incbin", errors)
        require(build_gradle, zip_name, "gradle generated bootstrap outputs", errors)
        require(build_script, zip_name, "bootstrap generation script", errors)

    require(build_gradle, "generateRafcodephiBootstraps", "gradle task", errors)
    require(build_gradle, "scripts/build_rafaelia_bootstraps.sh", "gradle task", errors)
    require(build_gradle, "preBuild", "gradle task", errors)
    require(build_gradle, "externalNativeBuild", "gradle task", errors)
    require(build_gradle, "generateJsonModel", "gradle task", errors)

    if build_gradle.count('implementation project(":termux-shared")') != 1:
        errors.append("app/build.gradle: termux-shared dependency must appear exactly once")

    for runtime_file in RUNTIME_FILES:
        require(build_script, runtime_file, "bootstrap source generator", errors)
        require(builder, runtime_file, "bootstrap zip builder", errors)

    for marker in (
        "BOOTSTRAP_UTILS_READY=1",
        "BOOTSTRAP_APKMANAGER_READY=1",
        "BOOTSTRAP_SHELLBASH_READY=1",
        "BOOTSTRAP_BUSYBOX_SAFE_READY=1",
        "BOOTSTRAP_PROOT_SAFE_READY=1",
        "RUNTIME_READY=1",
        "BOOTSTRAP_PACKAGE_INSTALLABLE=1",
        "SYMLINKS.txt",
        "raf-bootstrap-sh",
    ):
        require(builder, marker, "bootstrap zip builder metadata", errors)

    for installer_token in (
        "verifyBootstrapZipIntegrity(zipBytes)",
        "verifyRuntimeBinary(TERMUX_STAGING_PREFIX_DIR_PATH + \"/bin/sh\", \"sh\")",
        "verifyRuntimeBinary(TERMUX_STAGING_PREFIX_DIR_PATH + \"/bin/busybox\", \"busybox\")",
        "verifyRuntimeBinary(TERMUX_STAGING_PREFIX_DIR_PATH + \"/bin/proot\", \"proot\")",
        "BootstrapBaremetalGuard.validateAfterBootstrap(TERMUX_PREFIX_DIR_PATH)",
        "rollbackFailedBootstrapInstall",
    ):
        require(installer, installer_token, "installer", errors)

    return errors


def main() -> int:
    errors = validate()
    if errors:
        print("bootstrap_package_install_contract=FAIL")
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        return 1
    print("bootstrap_package_install_contract=PASS")
    print("claim_boundary=structural_only_no_device_runtime_claim")
    print("bootstrap_generation=gradle_prebuild_wired")
    print("native_incbin=rewritten_bootstrap_packages_declared")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
