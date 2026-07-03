# Bootstrap Package Install Not Found Hotfix

## Status

`hotfix / bootstrap_package_discovery / claim_limited`

## Problem

The native bootstrap embedder consumes installable bootstrap ZIP files by name:

```text
rewritten-bootstrap-i686.zip
rewritten-bootstrap-x86_64.zip
rewritten-bootstrap-aarch64.zip
rewritten-bootstrap-arm.zip
```

through:

```text
app/src/main/cpp/termux-bootstrap-zip.S
```

If these files are not generated before native build, the native `.incbin` path cannot find the bootstrap package.

A second source of failure existed in the local bootstrap builder: the source generator created runtime shims, but the C ZIP builder did not include all of them in the generated ZIP.

## Hotfix applied

### 1. Gradle generation before native incbin

`app/build.gradle` now registers:

```text
generateRafcodephiBootstraps
```

It runs:

```text
scripts/build_rafaelia_bootstraps.sh
```

before `preBuild`, `externalNativeBuild*` and `generateJsonModel*` tasks.

The generated outputs are:

```text
app/src/main/cpp/rewritten-bootstrap-aarch64.zip
app/src/main/cpp/rewritten-bootstrap-arm.zip
app/src/main/cpp/rewritten-bootstrap-i686.zip
app/src/main/cpp/rewritten-bootstrap-x86_64.zip
```

### 2. Runtime shims are now packaged

`scripts/bootstrap_zip_builder.c` now loads and emits:

```text
bin/sh
bin/pkg
bin/busybox
bin/proot
bin/apkmanager
bin/shellbash
bin/busybox-safe
bin/proot-safe
etc/motd
```

The metadata now includes:

```text
BOOTSTRAP_UTILS_READY=1
BOOTSTRAP_APKMANAGER_READY=1
BOOTSTRAP_SHELLBASH_READY=1
BOOTSTRAP_BUSYBOX_SAFE_READY=1
BOOTSTRAP_PROOT_SAFE_READY=1
RUNTIME_READY=1
BOOTSTRAP_PACKAGE_INSTALLABLE=1
```

### 3. Non-empty SYMLINKS manifest

The generated local bootstrap ZIP now includes a non-empty `SYMLINKS.txt` entry:

```text
sh←bin/raf-bootstrap-sh
```

This keeps the installer path compatible with its symlink-processing contract instead of producing a bootstrap package that can be extracted but later rejected as having no symlink manifest content.

## What this fixes

```text
native bootstrap package not found before build
runtime utility shims missing from generated bootstrap zip
empty generated SYMLINKS manifest
bootstrap source generator / zip builder mismatch
```

## What this does not claim

This hotfix does not claim:

```text
real-device install passed
Moto E7 runtime passed
TermuxService command passed
busybox/proot production payload quality
performance improvement
root success
SAF/scoped-storage bypass
absence of bugs
```

## Required verification

Structural repository check:

```sh
python tools/validate_bootstrap_package_install_contract.py
pytest -q tests/test_bootstrap_package_install_contract.py
```

Build check:

```sh
./gradlew :app:assembleDebug
```

Device check after installing the APK:

```sh
sh scripts/smoke_bootstrap_filesystem_proot_busybox_service.sh
```

## Operational verdict

```text
BOOTSTRAP_PACKAGE_GENERATION = GRADLE_WIRED
NATIVE_INCBIN_INPUTS = GENERATED_BEFORE_NATIVE_BUILD
RUNTIME_SHIMS_IN_ZIP = GUARDED
SYMLINKS_MANIFEST = NON_EMPTY
DEVICE_RUNTIME = STILL_REQUIRES_DEVICE_SMOKE
PERFORMANCE_CLAIMS = BLOCKED_UNTIL_MEASURED
```
