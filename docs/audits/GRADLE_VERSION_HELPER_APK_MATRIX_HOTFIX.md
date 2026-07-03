# Gradle Version Helper APK Matrix Hotfix

## Status

`build_config_hotfix / claim_boundary`

## Context

The APK matrix build reached bootstrap generation successfully, then failed during Gradle project evaluation with a missing `validateVersionName` method in `defaultConfig`.

This was a Gradle DSL/configuration failure, not a bootstrap ZIP failure.

## Applied fix

`app/build.gradle` now defines the helpers before the `android` block:

```text
validateVersionName(candidateVersionName)
hasReleaseTaskRequested()
```

The `defaultConfig` block now computes `effectiveVersionName`, validates that value, and then assigns it to the Android DSL `versionName`.

## Regression guard

`tools/validate_bootstrap_package_install_contract.py` now checks that:

```text
validateVersionName helper is present
hasReleaseTaskRequested helper is present
effectiveVersionName is used
validateVersionName(versionName) is absent
```

`tests/test_bootstrap_package_install_contract.py` covers the same contract.

## Claim boundary

This hotfix only addresses Gradle configuration readiness for APK matrix evaluation.

It does not claim:

- device runtime validation;
- physical device install success;
- bootstrap runtime success;
- filesystem throughput;
- native speedup;
- performance improvement.

## Expected next verification

Run:

```bash
./scripts/build_apk_matrix.sh
```

The previously observed failure should not reoccur at `validateVersionName` resolution. If the build fails later, that later failure must be classified separately.
