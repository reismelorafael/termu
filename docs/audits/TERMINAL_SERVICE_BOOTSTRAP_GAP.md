# Terminal Service Bootstrap Gap

## Status

`terminal_service_bootstrap_gap / service_execution_boundary / claim_limited`

## Context

`TermuxActivity` gates the normal first interactive session through:

```text
storage permission callback
-> TermuxInstaller.setupStorageSymlinks(...)
-> startAndBindTermuxServiceOrFail()
-> TermuxInstaller.setupBootstrapIfNeeded(...)
-> createInitialSession(...)
```

That path is guarded for the normal launcher flow.

`TermuxService` also owns execution paths that can create foreground terminal sessions and background tasks:

```text
ACTION_SERVICE_EXECUTE
-> actionServiceExecute(...)
-> executeTermuxTaskCommand(...)
-> createTermuxTask(...)

ACTION_SERVICE_EXECUTE
-> actionServiceExecute(...)
-> executeTermuxSessionCommand(...)
-> createTermuxSession(...)
```

## Gap

The remaining runtime hardening gap is to add a service-level bootstrap readiness check immediately before `createTermuxTask(...)` and `createTermuxSession(...)` execute shell commands.

The intended check is:

```text
if normal execution:
  validate $PREFIX/bin/sh
  validate $PREFIX/bin/pkg
  validate $HOME / $HOME/storage internal readiness
  fail clearly before spawning if missing

if failsafe execution:
  preserve failsafe behavior and do not make normal bootstrap mandatory
```

## Why this matters

The activity wizard protects the normal first terminal path. A service/plugin execution path should not assume that the activity bootstrap path has already succeeded unless it can prove the same `$PREFIX` readiness.

## Boundary

This document does not claim:

```text
service-level runtime guard is already implemented in Java
plugin execution is device-validated
root/system install is complete
external storage is always granted
busybox/proot real binaries are present
performance is improved
```

## What was not applied

A direct Java patch to `TermuxService.java` was not applied in this step because the available GitHub content API only exposes full-file replacement, and replacing this large service file without a partial patch would increase regression risk.

## Next safe code patch

Implement a small method in `TermuxService`:

```text
ensureBootstrapReadyForExecution(executionCommand, phase)
```

and call it before:

```text
AppShell.execute(...)
TermuxSession.execute(...)
```

The method should call the existing install guard for normal execution and convert failures into plugin/user-visible execution errors without killing the process unexpectedly.

## Operational verdict

```text
NORMAL_ACTIVITY_FIRST_SESSION = GUARDED
SERVICE_PLUGIN_EXECUTION_BOOTSTRAP_GUARD = TOKEN_VAZIO_CODE_PATCH
FAILSAFE_SESSION_COMPATIBILITY = MUST_PRESERVE
DEVICE_RUNTIME_SMOKE = PENDING
```
