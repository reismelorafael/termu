# ARM32 Install Filesystem / Shell Guard

## Status

`install_hotfix / filesystem_shell_guard / claim_limited`

## Repository

`exacordex-crypto/termux-app-rafacodephi`

## Purpose

This note records the installation-level guard added for `armeabi-v7a` / ARM32 and other ABIs.

The guard is part of the bootstrap installation path because it runs from `BootstrapBaremetalGuard.validateAfterBootstrap(...)`, immediately after the staging prefix is renamed into the final `$PREFIX`.

## What the guard enforces

The install guard now requires and/or creates the internal app filesystem pieces that must exist before shell startup:

```text
$PREFIX
$PREFIX/bin
$PREFIX/etc
$PREFIX/etc/termux
$PREFIX/tmp
$PREFIX/var
$PREFIX/var/tmp
$HOME
$HOME/.termux
$HOME/.config/termux
$HOME/storage
```

It also verifies owner-executable permission for:

```text
$PREFIX/bin/sh
$PREFIX/bin/pkg
```

## Android storage boundary

`$HOME/storage` is created as an internal placeholder during installation. This does not require external storage permission.

Android external/shared-storage links remain handled by the normal storage setup path and may still depend on Android runtime permission and scoped-storage policy. The install guard does not pretend that external storage is granted.

## ARM32 / V7 boundary

The guard logs the primary ABI and explicitly records when the primary ABI is `armeabi-v7a`.

This is an installation-readiness guard for ARM32 shell/filesystem startup, not a device benchmark.

## Claims blocked

This change does not claim:

- external Android storage permission has been granted;
- SAF/scoped-storage policy is bypassed;
- runtime on a real ARM32 device has been fully validated;
- NEON/SIMD speedup;
- filesystem throughput improvement;
- absence of bugs.

## Operational verdict

```text
INSTALL_FILESYSTEM_MINIMUM = GUARDED
INSTALL_SHELL_BIN_SH = REQUIRED_EXECUTABLE
INSTALL_PACKAGE_MANAGER_BIN_PKG = REQUIRED_EXECUTABLE
ANDROID_EXTERNAL_STORAGE_PERMISSION = NOT_ASSUMED
ARM32_DEVICE_RUNTIME_PROOF = STILL_REQUIRES_DEVICE_SMOKE
```
