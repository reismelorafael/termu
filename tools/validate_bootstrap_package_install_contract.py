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
APPLICATION = ROOT / "app/src/main/java/com/termux/app/TermuxApplication.java"

REWRITTEN_ZIPS = (
    "rewritten-bootstrap-aarch64.zip",
    "rewritten-bootstrap-arm.zip",
    "rewritten-bootstrap-i686.zip",
    "rewritten-bootstrap_x86_64.zip".replace("_x86", "-x86"),
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

COMMAND_WRAPPER_APPLETS = (
    "cat",
    "ls",
    "clear",
    "grep",
    "sed",
    "awk",
    "head",
    "tail",
    "wc",
    "mkdir",
    "rm",
    "cp",
    "mv",
    "ln",
    "chmod",
    "pwd",
    "env",
    "which",
    "find",
    "tar",
    "gzip",
    "gunzip",
    "zcat",
    "stat",
    "strings",
    "file",
    "whoami",
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
    application = read(APPLICATION, errors)

    for zip_name in REWRITTEN_ZIPS:
        require(asm, f'.incbin "{zip_name}"', "native incbin", errors)
        require(build_gradle, zip_name, "gradle generated bootstrap outputs", errors)
        require(build_script, zip_name, "bootstrap generation script", errors)

    require(build_gradle, "generateRafcodephiBootstraps", "gradle task", errors)
    require(build_gradle, "scripts/build_rafaelia_bootstraps.sh", "gradle task", errors)
    require(build_gradle, "preBuild", "gradle task", errors)
    require(build_gradle, "externalNativeBuild", "gradle task", errors)
    require(build_gradle, "generateJsonModel", "gradle task", errors)

    for token in (
        "def validateVersionName(String candidateVersionName)",
        "def hasReleaseTaskRequested()",
        "def effectiveVersionName = appVersionName ?: \"0.118.0\"",
        "validateVersionName(effectiveVersionName)",
        "versionName effectiveVersionName",
    ):
        require(build_gradle, token, "gradle version helper", errors)
    if "validateVersionName(versionName)" in build_gradle:
        errors.append("app/build.gradle: validateVersionName must not be called on Gradle DSL versionName")

    if build_gradle.count('implementation project(":termux-shared")') != 1:
        errors.append("app/build.gradle: termux-shared dependency must appear exactly once")

    for runtime_file in RUNTIME_FILES:
        require(build_script, runtime_file, "bootstrap source generator", errors)
        require(builder, runtime_file, "bootstrap zip builder", errors)

    for token in (
        "runtime_command_wrappers",
        "write_busybox_applet_wrapper",
        "${generated_root}/bin/${app}",
        "command_wrapper_names",
        "wrapper_paths",
        "bin/%s",
        "load_file(payload_root,wrapper_paths[i],wrapper_bufs[i],&wrapper_sizes[i])",
    ):
        require(build_script + "\n" + builder, token, "explicit busybox command wrapper machinery", errors)

    for applet in COMMAND_WRAPPER_APPLETS:
        require(build_script, applet, "explicit busybox command wrapper source applet list", errors)
        require(builder, f'"{applet}"', "explicit busybox command wrapper zip applet list", errors)

    for marker in (
        "BOOTSTRAP_UTILS_READY=1",
        "BOOTSTRAP_APKMANAGER_READY=1",
        "BOOTSTRAP_SHELLBASH_READY=1",
        "BOOTSTRAP_BUSYBOX_SAFE_READY=1",
        "BOOTSTRAP_PROOT_SAFE_READY=1",
        "RUNTIME_READY=1",
        "BOOTSTRAP_PACKAGE_INSTALLABLE=1",
        "BOOTSTRAP_COMMAND_WRAPPERS_READY=1",
        "BOOTSTRAP_EXPLICIT_APPLET_WRAPPERS=1",
        "EXPLICIT_APPLET_WRAPPERS_READY=1",
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
        "TermuxShellEnvironment.writeEnvironmentToFile(activity)",
        "rollbackFailedBootstrapInstall",
    ):
        require(installer, installer_token, "installer", errors)

    for application_token in (
        "initializeInstalledBootstrapEnvironment()",
        "writeShellEnvironmentFile(\"application-startup\")",
        "new File(TermuxConstants.TERMUX_PREFIX_DIR_PATH + \"/bin/sh\")",
        "new File(TermuxConstants.TERMUX_PREFIX_DIR_PATH + \"/bin/pkg\")",
        "BootstrapBaremetalGuard.validateAfterBootstrap(TermuxConstants.TERMUX_PREFIX_DIR_PATH)",
        "bootstrap-env-init phase=guard-existing-prefix",
        "TermuxShellEnvironment.writeEnvironmentToFile(this)",
    ):
        require(application, application_token, "application bootstrap env init", errors)

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
    print("gradle_version_helpers=present_and_safe")
    print("existing_bootstrap_environment_init=application_startup_guarded")
    print("explicit_busybox_command_wrappers=present")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
