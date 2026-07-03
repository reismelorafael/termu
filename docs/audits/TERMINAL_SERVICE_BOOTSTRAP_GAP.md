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
plugin execution is device-validated
root/system install is complete
external storage is always granted
busybox/proot real binaries are present
performance is improved
```

## Code patch applied

`TermuxService` now implements:

```text
ensureBootstrapReadyForExecution(executionCommand, phase)
failExecutionCommandOnBootstrapNotReady(executionCommand, bootstrapError)
```

`ensureBootstrapReadyForExecution` is called immediately before:

```text
AppShell.execute(...)      in createTermuxTask(ExecutionCommand)
TermuxSession.execute(...) in createTermuxSession(ExecutionCommand)
```

For a non-failsafe `executionCommand` it reuses the existing install guard
(`TermuxQualityManager.checkBootstrapComplete()`, which validates `$PREFIX`,
`$PREFIX/bin`, `$HOME` and `$PREFIX/bin/sh`) and additionally validates
`$PREFIX/bin/pkg`. A failsafe `executionCommand` (`isFailsafe == true`) is never
gated, so failsafe session compatibility is preserved.

When bootstrap is not ready, `failExecutionCommandOnBootstrapNotReady` converts
the failure into `executionCommand.setStateFailed(...)`, routes it through
`TermuxPluginUtils.processPluginExecutionCommandError(...)` for plugin-originated
commands, and removes it from the pending plugin execution commands list. The
service process itself is not killed; only that single task/session creation is
aborted before a broken shell would have been spawned.

## Operational verdict

```text
NORMAL_ACTIVITY_FIRST_SESSION = GUARDED
SERVICE_PLUGIN_EXECUTION_BOOTSTRAP_GUARD = IMPLEMENTED
FAILSAFE_SESSION_COMPATIBILITY = MUST_PRESERVE
DEVICE_RUNTIME_SMOKE = PENDING
```
