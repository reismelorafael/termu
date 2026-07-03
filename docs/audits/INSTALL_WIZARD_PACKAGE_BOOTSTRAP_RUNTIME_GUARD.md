# Install Wizard Package / Bootstrap / Runtime Guard

## Status

`install_wizard_guard / package_bootstrap_runtime / claim_limited`

## Purpose

This note records the installation contract after the Android write/storage permission step in the installation wizard.

The current activity flow requests storage access before starting the service. After permission callback, it calls the storage setup path and then starts/binds the service. The service connection then runs `TermuxInstaller.setupBootstrapIfNeeded(...)` before the initial shell session is created.

## Required internal install contract

After permission is granted and before the first interactive shell is considered ready, the app must keep the following pieces guarded:

```text
$PREFIX/bin/sh
$PREFIX/bin/pkg
$PREFIX/bin/apkmanager
$PREFIX/bin/shellbash
$PREFIX/bin/busybox-safe
$PREFIX/bin/proot-safe
$HOME/storage
```

## Boundary

`busybox-safe` and `proot-safe` are safe launcher shims. They may exist even when the real optional binaries are not present. If the real optional binary is absent, the shim must fail clearly instead of pretending the binary exists.

## Android permission boundary

Storage permission grants Android shared/external storage access. It does not prove device runtime, SAF bypass, performance, or filesystem speedup.

## Operational verdict

```text
WRITE_PERMISSION_CALLBACK = INSTALL_WIZARD_GATE
STORAGE_SYMLINKS_AFTER_PERMISSION = REQUIRED
BOOTSTRAP_INSTALL_AFTER_PERMISSION = REQUIRED_VIA_SERVICE_BIND
PKG_INSTALL_INTERFACE = REQUIRED
APKMANAGER_SHIM = REQUIRED
SHELLBASH_SHIM = REQUIRED
BUSYBOX_SAFE_SHIM = REQUIRED
PROOT_SAFE_SHIM = REQUIRED
REAL_BUSYBOX_BINARY = OPTIONAL_BOOTSTRAP_PAYLOAD
REAL_PROOT_BINARY = OPTIONAL_BOOTSTRAP_PAYLOAD
DEVICE_RUNTIME_PROOF = STILL_REQUIRES_DEVICE_SMOKE
```
