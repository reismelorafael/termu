# README Runtime Claim Boundary Hotfix

## Status

`documentation_hotfix / runtime_claim_boundary / no_device_claim`

## Scope

This document records a narrow README claim-boundary hotfix for `exacordex-crypto/termux-app-rafacodephi`.

The README is a public entry point and may contain historical or aspirational wording. Public wording must not outrun the measurable state of the app.

## Risk observed

The README contains strong public-facing terms around Android 15/16 compatibility and native acceleration. These phrases must be interpreted as configuration or engineering intent unless there is matching runtime evidence.

Risk terms include:

```text
fully compatible
will NOT crash
NEON/SIMD optimized
```

## Correct claim boundary

Allowed:

```text
The repository is configured for side-by-side RAFCODEPHI package identity.
The Gradle/NDK configuration declares 16KB page-size alignment flags.
The bootstrap/package contract is structurally guarded.
ARM32/ARM64/x86_64 build paths are represented in the source and CI contracts.
```

Blocked until measured on a real device:

```text
Android 15/16 runtime compatibility is proven.
The app will not crash on every Android 15/16 device.
NEON/SIMD provides measured speedup.
Filesystem throughput is improved.
Moto E7 Power / ARM32 runtime is validated.
```

## Evidence path required before stronger wording

To promote any runtime/performance claim, require at minimum:

```text
repo commit
APK variant
ABI
device model
Android version
kernel/page-size observation
install log
first-session log
bootstrap smoke result
service smoke result
metric output
baseline or previous build
claim boundary
```

## Existing supporting artifacts

The repository already contains structural and smoke-test guardrails. They are useful, but they do not replace physical-device execution.

Relevant paths:

```text
docs/audits/FLORENCE_FILESYSTEM_HARDWARE_DIAGNOSTIC.md
docs/audits/BENCHMARK_WIZARD_FILESYSTEM_OPERATIONAL_EXCELLENCE.md
docs/audits/BOOTSTRAP_FILESYSTEM_PROOT_BUSYBOX_SERVICE_EXECUTION_GUARD.md
scripts/smoke_bootstrap_filesystem_proot_busybox_service.sh
tools/validate_benchmark_wizard_filesystem_contract.py
tools/validate_bootstrap_package_install_contract.py
```

## Operational verdict

```text
README_PUBLIC_WORDING = CLAIM_BOUNDARY_REQUIRED
GRADLE_BOOTSTRAP_HOTFIX = APPLIED_SEPARATELY
DEVICE_RUNTIME = PENDING_REAL_DEVICE_SMOKE
PERFORMANCE_CLAIMS = BLOCKED_UNTIL_MEASURED
```

## Non-goal

This hotfix does not rewrite the full README in this commit. It records the boundary and adds a validator so the repository does not silently treat README wording as runtime proof.
