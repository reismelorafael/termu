from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def test_gradle_generates_rewritten_bootstraps_before_native_incbin() -> None:
    build_gradle = (ROOT / "app/build.gradle").read_text(encoding="utf-8")
    asm = (ROOT / "app/src/main/cpp/termux-bootstrap-zip.S").read_text(encoding="utf-8")

    for zip_name in [
        "rewritten-bootstrap-aarch64.zip",
        "rewritten-bootstrap-arm.zip",
        "rewritten-bootstrap-i686.zip",
        "rewritten-bootstrap-x86_64.zip",
    ]:
        assert zip_name in build_gradle
        assert f'.incbin "{zip_name}"' in asm

    assert "generateRafcodephiBootstraps" in build_gradle
    assert "scripts/build_rafaelia_bootstraps.sh" in build_gradle
    assert "dependsOn(tasks.named(\"generateRafcodephiBootstraps\"))" in build_gradle
    assert build_gradle.count('implementation project(":termux-shared")') == 1


def test_zip_builder_packages_runtime_utility_shims() -> None:
    builder = (ROOT / "scripts/bootstrap_zip_builder.c").read_text(encoding="utf-8")

    for token in [
        "bin/sh",
        "bin/pkg",
        "bin/busybox",
        "bin/proot",
        "bin/apkmanager",
        "bin/shellbash",
        "bin/busybox-safe",
        "bin/proot-safe",
        "BOOTSTRAP_UTILS_READY=1",
        "BOOTSTRAP_APKMANAGER_READY=1",
        "BOOTSTRAP_SHELLBASH_READY=1",
        "BOOTSTRAP_BUSYBOX_SAFE_READY=1",
        "BOOTSTRAP_PROOT_SAFE_READY=1",
        "RUNTIME_READY=1",
        "BOOTSTRAP_PACKAGE_INSTALLABLE=1",
        "SYMLINKS.txt",
        "raf-bootstrap-sh",
    ]:
        assert token in builder


def test_bootstrap_source_generator_creates_files_that_zip_builder_requires() -> None:
    build_script = (ROOT / "scripts/build_rafaelia_bootstraps.sh").read_text(encoding="utf-8")

    for token in [
        "${generated_root}/bin/sh",
        "${generated_root}/bin/pkg",
        "${generated_root}/bin/busybox",
        "${generated_root}/bin/proot",
        "${generated_root}/bin/apkmanager",
        "${generated_root}/bin/shellbash",
        "${generated_root}/bin/busybox-safe",
        "${generated_root}/bin/proot-safe",
        "rewritten-bootstrap-aarch64.zip",
        "rewritten-bootstrap-arm.zip",
        "rewritten-bootstrap-i686.zip",
        "rewritten-bootstrap-x86_64.zip",
    ]:
        assert token in build_script


def test_installer_keeps_integrity_runtime_and_rollback_guards() -> None:
    installer = (ROOT / "app/src/main/java/com/termux/app/TermuxInstaller.java").read_text(
        encoding="utf-8"
    )

    for token in [
        "verifyBootstrapZipIntegrity(zipBytes)",
        "verifyRuntimeBinary(TERMUX_STAGING_PREFIX_DIR_PATH + \"/bin/sh\", \"sh\")",
        "verifyRuntimeBinary(TERMUX_STAGING_PREFIX_DIR_PATH + \"/bin/busybox\", \"busybox\")",
        "verifyRuntimeBinary(TERMUX_STAGING_PREFIX_DIR_PATH + \"/bin/proot\", \"proot\")",
        "BootstrapBaremetalGuard.validateAfterBootstrap(TERMUX_PREFIX_DIR_PATH)",
        "rollbackFailedBootstrapInstall",
    ]:
        assert token in installer


def test_validator_is_claim_bounded_and_tracks_installability() -> None:
    validator = (ROOT / "tools/validate_bootstrap_package_install_contract.py").read_text(
        encoding="utf-8"
    )

    for token in [
        "bootstrap_package_install_contract=PASS",
        "claim_boundary=structural_only_no_device_runtime_claim",
        "bootstrap_generation=gradle_prebuild_wired",
        "native_incbin=rewritten_bootstrap_packages_declared",
    ]:
        assert token in validator
