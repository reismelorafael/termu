# Debug Bootstrap Test Report

Date (UTC): 2026-05-14
Repository: `termux-app-rafacodephi`
Mode: `RAF_BOOTSTRAP_SOURCE=local`

## Results

1. Command: `bash scripts/verify_bootstrap_contract.sh --prepare-dev`
   - Status: **PASS**
   - APK generated: **No** (preparation/validation step)
   - APK path: `N/A`
   - Notes: local bootstrap archives were generated and validated; `b3sum` missing was treated as warning and SHA256 hashes were emitted.

2. Command: `RAF_BOOTSTRAP_SOURCE=local ./gradlew :app:ensureBootstrapArchives --no-daemon`
   - Status: **FAIL**
   - APK generated: **No**
   - APK path: `N/A`
   - Real error: `SDK location not found. Define a valid SDK location with an ANDROID_HOME environment variable or by setting the sdk.dir path in local.properties`.

3. Command: `RAF_BOOTSTRAP_SOURCE=local ./gradlew assembleDebug --no-daemon`
   - Status: **FAIL**
   - APK generated: **No**
   - APK path: `N/A`
   - Real error: `SDK location not found. Define a valid SDK location with an ANDROID_HOME environment variable or by setting the sdk.dir path in local.properties`.

## Final APK Output

- APK generated: **No**
- Expected path when successful: `app/build/outputs/apk/debug/app-debug.apk`

## Blocking issue

- Android SDK is not installed/configured in this environment, so Gradle cannot configure `:app` and cannot run debug build tasks.
