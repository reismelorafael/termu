# Benchmark / Wizard / Filesystem Operational Excellence Contract

## Status

`operational_contract / benchmark_wizard_filesystem / claim_limited`

## Repository

`exacordex-crypto/termux-app-rafacodephi`

## Purpose

This document makes the RAFCODEPHI Termux differential explicit and measurable without inflating claims.

The operational goal is not to say "the filesystem is faster" before evidence exists. The operational goal is:

```text
filesystem path as a first-class differential
-> benchmark contract
-> install wizard readiness contract
-> runtime metric envelope
-> fallback/rollback discipline
-> device-smoke proof before performance claims
```

## Core thesis

The filesystem is a real differential in this fork because Termux is not only an Android UI. It is also the boundary where these layers meet:

```text
Android permission model
app-private prefix
bootstrap payload
shell startup
package manager interface
native scanner/indexer paths
artifact production
runtime logs
user-visible terminal session
```

A filesystem improvement is only operationally excellent when it is expressed as measured behavior across those layers, not as a slogan.

## What must be guaranteed

### 1. Benchmark contract

Every benchmark intended to support a claim must record at least:

```text
benchmark_id
repo_commit
apk_variant
abi
android_version
kernel_version
device_model
storage_state
thermal_state_when_available
command_or_workflow
input_artifact
output_artifact
metric_name
metric_value
metric_unit
baseline
failure_mode
claim_boundary
```

The minimum benchmark families for this fork are:

```text
BUILD_TIME
APK_SIZE
BOOTSTRAP_INSTALL_TIME
FIRST_SESSION_START_TIME
PREFIX_READINESS_TIME
PKG_STARTUP_TIME
FILESYSTEM_SCAN_THROUGHPUT
FILESYSTEM_SCAN_LATENCY
CTI_SCAN_TIME
ZIPRAF_INDEX_TIME
NATIVE_FALLBACK_EQUIVALENCE
STABILITY_RESTART
JITTER_OR_VARIANCE
```

### 2. Wizard readiness contract

The install wizard is only considered operationally coherent if the first interactive session is guarded by:

```text
Android write/storage permission path
-> storage symlink setup path
-> service bind path
-> bootstrap setup path
-> filesystem/shell guard
-> first session creation
```

Required post-permission readiness targets:

```text
$PREFIX/bin/sh
$PREFIX/bin/pkg
$PREFIX/bin/apkmanager
$PREFIX/bin/shellbash
$PREFIX/bin/busybox-safe
$PREFIX/bin/proot-safe
$HOME/storage
```

### 3. Filesystem differential contract

The filesystem layer can be described as a differential only when it is tied to concrete observable properties:

```text
prefix completeness
shell executability
package command availability
safe optional utility shims
storage placeholder/symlink behavior
native scan/index path readiness
artifact checksums
rollback/failback behavior
```

This does not mean external Android shared storage is automatically granted. It also does not mean SAF/scoped-storage policy is bypassed.

### 4. Metrics coherence contract

Metrics must be coherent across build, artifact, install, runtime and benchmark layers.

Required coherence rules:

```text
metric has unit
metric has baseline
metric has environment
metric has command
metric has artifact
metric has failure state
metric has claim boundary
missing input is TOKEN_VAZIO, not PASS
runtime pending is PENDING, not VALIDATED
benchmark absent blocks performance claim
```

### 5. Operational excellence gate

No optimization should be accepted only because it sounds low-level.

Every filesystem/native fast path must pass this gate:

```text
capability detection
-> fast path
-> scalar/fallback path
-> deterministic equivalence test
-> bounds and buffer check
-> non-destructive failure behavior
-> rollback/failback behavior
-> artifact/log output
-> metric emission
-> claim boundary
```

## Claims allowed

The repository may claim:

```text
benchmark contract is defined
wizard readiness contract is defined
filesystem differential is expressed as measurable operational boundary
artifact hygiene is structurally validated
claim boundary blocks performance inflation
```

## Claims blocked until measured

The repository must not claim, from this contract alone:

```text
NEON speedup measured
SIMD speedup measured
L1/L2 cache efficiency measured
filesystem throughput improved
first session startup improved
Android shared storage bypassed
real device runtime passed
production certification
absence of bugs
universal hardware superiority
```

## Operational verdict

```text
BENCHMARK_CONTRACT = GUARDED
WIZARD_READINESS_CONTRACT = GUARDED
FILESYSTEM_DIFFERENTIAL = CLAIM_BOUNDED_OPERATIONAL_LAYER
METRICS_COHERENCE = REQUIRED
DEVICE_RUNTIME_PROOF = STILL_REQUIRES_DEVICE_SMOKE
PERFORMANCE_CLAIMS = BLOCKED_UNTIL_MEASURED
```

## Next implementation step

The next executable step is to emit a machine-readable benchmark manifest from device smoke or CI artifact validation, using this document as the minimum schema.

Recommended target path:

```text
results/benchmarks/rafcodephi_filesystem_wizard_metrics.json
```

Recommended validator path:

```text
tools/validate_benchmark_wizard_filesystem_contract.py
```
