# Bootstrap / Filesystem / Proot / Busybox / Service Execution Guard

## Status

`runtime_smoke_contract / service_execution_guard / claim_limited`

## Purpose

This document records the executable guard for the RAFCODEPHI Termux runtime path requested by the operational contract:

```text
bootstrap
-> filesystem
-> sh/pkg
-> apkmanager/shellbash
-> busybox-safe/proot-safe
-> TermuxService.ACTION_SERVICE_EXECUTE
-> marker written by service-executed command
```

The guard is implemented as a real-device smoke script:

```text
scripts/smoke_bootstrap_filesystem_proot_busybox_service.sh
```

## What the smoke executes

The script must run inside an installed RAFCODEPHI Termux session on a real Android device.

It checks and executes:

```text
$PREFIX/bin/sh
$PREFIX/bin/pkg
$PREFIX/bin/apkmanager
$PREFIX/bin/shellbash
$PREFIX/bin/busybox-safe
$PREFIX/bin/proot-safe
```

It also checks required directories:

```text
$PREFIX
$PREFIX/bin
$PREFIX/tmp
$PREFIX/var
$HOME
$HOME/storage
```

Then it writes a temporary marker script under:

```text
$PREFIX/tmp/rafcodephi-service-smoke.sh
```

and dispatches it through:

```text
am startservice
  -n com.termux.rafacodephi/com.termux.app.TermuxService
  -a com.termux.rafacodephi.service_execute
  -d com.termux.rafacodephi.file://$PREFIX/tmp/rafcodephi-service-smoke.sh
  --es com.termux.rafacodephi.execute.runner app-shell
  --es com.termux.rafacodephi.execute.shell_name rafcodephi-service-smoke
  --es com.termux.rafacodephi.execute.shell_create_mode always
```

The smoke passes only if the service-executed command writes:

```text
$HOME/.termux/rafcodephi-smoke/service-executed.ok
```

## Optional binaries rule

`busybox-safe` and `proot-safe` are required as wrappers.

The real `busybox` and `proot` payloads may be absent in a minimal bootstrap. If the wrappers return `127`, the script records:

```text
TOKEN_VAZIO_OPTIONAL_BINARY
```

This is not a pass for real busybox/proot execution. It is a correct classification of wrapper-present / payload-absent state.

If real payloads are present, the wrappers must execute successfully.

## Claims allowed after a passing smoke

A passing real-device smoke allows only:

```text
filesystem readiness observed on that device/session
sh/pkg/apkmanager/shellbash executed
busybox-safe/proot-safe wrapper behavior exercised
TermuxService.ACTION_SERVICE_EXECUTE dispatched command
service-executed marker observed
```

## Claims blocked

The smoke does not claim:

```text
performance improvement
NEON/SIMD speedup
L1/L2 cache efficiency
filesystem throughput gain
SAF/scoped-storage bypass
root success
production certification
universal device compatibility
absence of bugs
```

## Operational verdict

```text
BOOTSTRAP_FILESYSTEM_SMOKE_SCRIPT = PRESENT
SERVICE_EXECUTION_MARKER = REQUIRED
BUSYBOX_PROOT_WRAPPERS = REQUIRED
REAL_BUSYBOX_PROOT_PAYLOADS = OPTIONAL_BUT_CLASSIFIED
PERFORMANCE_CLAIMS = BLOCKED_UNTIL_MEASURED
DEVICE_RUNTIME_PROOF = REQUIRES_RUNNING_SCRIPT_ON_DEVICE
```

## Device command

Inside the installed RAFCODEPHI Termux session:

```sh
sh scripts/smoke_bootstrap_filesystem_proot_busybox_service.sh
```

or after copying the script into the device session:

```sh
chmod 700 smoke_bootstrap_filesystem_proot_busybox_service.sh
./smoke_bootstrap_filesystem_proot_busybox_service.sh
```
