# FLORENCE Filesystem / Hardware Diagnostic

## Status

`diagnostic_note / operational_hotfix_boundary / claim_limited`

## Repository

`exacordex-crypto/termux-app-rafacodephi`

## Purpose

This note records the current filesystem, binary, ABI and hardware-orchestration state for the RAFCODEΦ Termux fork.

It is intentionally conservative. It separates:

- what is already implemented or built;
- what is documented but not measured on a live device;
- what should be optimized only behind dispatch, fallback and rollback gates.

## Evidence from repository

The repository already declares:

- Termux side-by-side identity: `com.termux.rafacodephi`;
- Android 15/16 compatibility and 16KB page-size alignment;
- RMR native module with C/ASM, thin JNI bridge and C fallback;
- Vectra-grade benchmark contract for build, binary, runtime, CPU, memory, I/O, stability and jitter metrics.

The low-level CTI scanner contract is already explicit about:

- fixed 4096-byte blocks;
- deterministic scan modes;
- zero malloc;
- static arrays;
- write-only output;
- inline CRC32C;
- ARM32 / ARM64 / x86_64 portable C11.

The `Android_nomalloc.mk` path already defines ARM32/ARM64 flags for NEON/ASM where applicable and 16KB page-size linker flags.

## Evidence from beta artifact ZIP

The uploaded beta artifact bundle contains:

- unsigned APKs by ABI and universal APK;
- signed release APKs by ABI and universal APK;
- SHA256SUMS;
- APK size report;
- release size diff report;
- beta build/readiness reports;
- bootstrap baremetal guard smoke output.

Observed artifact state from the bundle:

```text
CI remote = READY
build local without SDK = BLOCKED
runtime device = PENDING
BOOTSTRAP_BUILD_READY = YES
BOOTSTRAP_NATIVE_EMBED_READY = YES
BOOTSTRAP_BLAKE3_READY = YES
BOOTSTRAP_RUNTIME_PENDING = YES
BOOTSTRAP_ARTIFACT_HYGIENE_READY = YES
```

The bundle also records:

```text
pss3_failure_report.txt: failure_trace.csv absent; skipping PSS3 audit
```

This is a real gap, not a failure to hide. The correct state is:

```text
PSS3_AUDIT = TOKEN_VAZIO_INPUT
```

until `failure_trace.csv` exists and is validated.

## Claim boundary

This diagnostic does not claim:

- measured NEON speedup;
- measured SIMD speedup;
- measured L1/L2 cache efficiency;
- measured filesystem latency improvement;
- live device runtime validation;
- production safety certification;
- ISO certification;
- absence of bugs;
- universal hardware superiority.

It only claims that the repository already has a low-level path, build artifacts and a documented benchmark contract that can be made stricter.

## Coherent hotfix policy

Do not add optimization by slogan.

Every optimization must pass this gate:

```text
capability detection
-> dedicated fast path
-> scalar/fallback path
-> deterministic equivalence test
-> bounds and buffer check
-> rollback/failback behavior
-> artifact/log output
-> claim boundary
```

## Filesystem/hardware strategy

### Safe to pursue

- fixed-size block scanning;
- explicit ABI matrix;
- 16KB page-size validation;
- JNI thin bridge only;
- static buffers where bounded;
- no heap in low-level scanner paths;
- scalar C fallback for every ASM/SIMD path;
- runtime CPU feature dispatch;
- CI artifact size/hash tracking;
- device smoke tests before runtime claims.

### Blocked until measured

- NEON/SIMD performance claims;
- L1/L2 cache-efficiency claims;
- branchless superiority claims;
- freestanding/no-libc runtime claims inside the Android app process;
- zero-overhead claims;
- no dependency claims across the full app;
- filesystem throughput claims;
- PSS3 audit claims without `failure_trace.csv`.

## Failsafe / failback / rollback requirements

Any future filesystem/native fast path must provide:

1. strict input bounds;
2. fixed output-size accounting;
3. deterministic return codes;
4. fallback C path;
5. feature flag or dispatch gate;
6. equivalent-output test against scalar path;
7. non-destructive failure behavior;
8. no deletion of prefix or app data on diagnostic failure;
9. logs without leaking secrets;
10. artifact manifest with checksums.

## Hex / flags discipline

Recommended explicit flags for low-level scanner and filesystem diagnostics:

```text
0x00 RAW/default/no-special-format
0x01 JPEG/header-detected
0x02 GIF/header-detected
0x04 PNG/header-detected
0x08 ZIP/header-detected
0x10 FAST_PATH_ELIGIBLE
0x20 FALLBACK_USED
0x40 BOUNDS_CLAMPED
0x80 ERROR_OR_INCOMPLETE
```

These flags are diagnostic states, not scientific proof or performance proof.

## Immediate next good patch

The most coherent next patch is not to add more assembler. It is to add a small validator that checks beta artifact completeness:

- `ARTIFACT_MANIFEST.txt` exists;
- `SHA256SUMS.txt` exists;
- release APKs exist for required ABIs;
- size reports exist;
- `pss3_failure_report.txt` is classified as `TOKEN_VAZIO_INPUT` when `failure_trace.csv` is absent;
- runtime/device smoke remains pending until ADB proof exists.

## Operational verdict

```text
BUILD_ARTIFACTS = PRESENT
ABI_APKS = PRESENT
SIGNED_RELEASE_APKS = PRESENT
BOOTSTRAP_GUARD = SMOKE_TESTED
PSS3_AUDIT = TOKEN_VAZIO_INPUT
RUNTIME_DEVICE_PROOF = PENDING
VECTRA_RUNTIME_BENCHMARKS = PENDING
FAST_PATH_PERFORMANCE_CLAIMS = BLOCKED_UNTIL_MEASURED
```

This keeps the project strong: it protects the valid low-level work without pretending that every hardware-performance claim has already been measured.
