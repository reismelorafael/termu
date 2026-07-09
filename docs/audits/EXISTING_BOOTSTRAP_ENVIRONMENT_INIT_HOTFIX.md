# Existing Bootstrap Environment Init Hotfix

## Status

`runtime_startup_hotfix / existing_bootstrap_env_init / claim_limited`

## Problem

The app may already have an installed bootstrap with:

```text
$PREFIX/bin/sh
$PREFIX/bin/pkg
```

In that case, the installer path can skip extraction because the bootstrap is already present. However, startup still needs to make sure the Termux environment is initialized before the first terminal/session/service path relies on it.

The relevant initialization is not another bootstrap download. It is:

```text
existing prefix guard
environment file write
$HOME / .termux / .config / storage placeholder readiness
```

## Hotfix applied

`app/src/main/java/com/termux/app/TermuxApplication.java` now performs an application-startup check after the Termux files directory is accessible and after `TermuxShellEnvironment.init(...)`.

If the existing prefix has both:

```text
$PREFIX/bin/sh
$PREFIX/bin/pkg
```

then it runs:

```text
BootstrapBaremetalGuard.validateAfterBootstrap($PREFIX)
```

and then writes the shell environment file through:

```text
TermuxShellEnvironment.writeEnvironmentToFile(...)
```

## Why this is the correct narrow fix

The bootstrap package can be present and installable, but startup still needs a coherent runtime environment for:

```text
HOME
PREFIX
PATH
TMPDIR
$HOME/.termux
$HOME/.config/termux
$HOME/storage placeholder
```

The existing `BootstrapBaremetalGuard.validateAfterBootstrap(...)` already creates/verifies the prefix, home, termux config/data dirs, storage placeholder, shell and package manager. Reusing it avoids inventing a second environment initializer.

## Claim boundary

This hotfix claims only:

```text
existing bootstrap prefix now triggers application-startup environment initialization structurally
```

It does not claim:

```text
physical device runtime passed
Moto E7 Power passed
Android 15/16 runtime passed
first interactive session passed
TermuxService command path passed
filesystem performance improved
NEON/SIMD speedup measured
root/Magisk behavior validated
```

## Required verification

Structural:

```sh
python3 tools/validate_bootstrap_package_install_contract.py
python3 -m pytest -q tests/test_bootstrap_package_install_contract.py
```

Build:

```sh
./scripts/build_apk_matrix.sh
```

Device smoke after install:

```sh
sh scripts/smoke_bootstrap_filesystem_proot_busybox_service.sh
```

## Operational verdict

```text
BOOTSTRAP_PRESENT = HANDLED
ENVIRONMENT_INIT = APPLICATION_STARTUP_GUARDED
SHELL_ENV_FILE = REWRITTEN_ON_STARTUP
HOME_CONFIG_STORAGE_PLACEHOLDER = GUARDED_BY_BOOTSTRAP_BAREMETAL_GUARD
DEVICE_RUNTIME = STILL_REQUIRES_DEVICE_SMOKE
PERFORMANCE_CLAIMS = BLOCKED_UNTIL_MEASURED
```
