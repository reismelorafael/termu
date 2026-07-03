#!/usr/bin/env python3
"""Apply narrow Android boot hotfixes before Gradle compilation.

This script is intentionally conservative: it only patches known source fragments
that block the first terminal session from being created on fresh installs.
"""

from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ACTIVITY = ROOT / "app/src/main/java/com/termux/app/TermuxActivity.java"
INSTALLER = ROOT / "app/src/main/java/com/termux/app/TermuxInstaller.java"
SESSION = ROOT / "termux-shared/src/main/java/com/termux/shared/termux/shell/command/runner/terminal/TermuxSession.java"


def replace_once(path: Path, old: str, new: str, label: str) -> bool:
    text = path.read_text(encoding="utf-8")
    if new in text:
        print(f"[boot-hotfix] {label}: already applied")
        return False
    if old not in text:
        raise SystemExit(f"[boot-hotfix] {label}: expected source fragment not found in {path}")
    path.write_text(text.replace(old, new, 1), encoding="utf-8")
    print(f"[boot-hotfix] {label}: applied")
    return True


def patch_activity_storage_gate() -> None:
    old = '''        // On Android 11+ (especially with targetSdk>=30), Termux will often touch primary external
        // storage (e.g. ~/storage/shared) early during initialization or soon after. If the user
        // has not granted legacy/managing external storage permission, this can lead to failures
        // that look like "opens then instantly closes". So we request permission BEFORE starting
        // the TermuxService.
        if (!ensureStorageAccessOrRequest()) {
            // Permission request UI has been launched. Wait for callback.
            return;
        }

        startAndBindTermuxServiceOrFail();
'''
    new = '''        // Storage permission is useful for ~/storage/shared, but it must not block the
        // first terminal session. Start the service regardless so the shell can boot;
        // permission/wizard flows remain auxiliary and can complete after startup.
        ensureStorageAccessOrRequest();
        startAndBindTermuxServiceOrFail();
'''
    replace_once(ACTIVITY, old, new, "activity storage gate")


def patch_installer_existing_prefix_exec_contract() -> None:
    old = '''            boolean hasRequiredBootstrapBinaries =
                FileUtils.fileExists(TERMUX_PREFIX_DIR_PATH + "/bin/sh", false) &&
                    FileUtils.fileExists(TERMUX_PREFIX_DIR_PATH + "/bin/pkg", false);

            if (TermuxFileUtils.isTermuxPrefixDirectoryEmpty()) {
                Logger.logInfo(LOG_TAG, "The termux prefix directory \"" + TERMUX_PREFIX_DIR_PATH + "\" exists but is empty or only contains specific unimportant files.");
            } else if (!hasRequiredBootstrapBinaries) {
                Logger.logWarn(LOG_TAG, "The termux prefix directory \"" + TERMUX_PREFIX_DIR_PATH +
                    "\" exists but is missing required bootstrap binaries. Reinstalling bootstrap.");
            } else {
                whenDone.run();
                return;
            }
'''
    new = '''            File existingShell = new File(TERMUX_PREFIX_DIR_PATH + "/bin/sh");
            File existingPkg = new File(TERMUX_PREFIX_DIR_PATH + "/bin/pkg");
            boolean hasRequiredBootstrapBinaries =
                FileUtils.fileExists(existingShell.getAbsolutePath(), false) &&
                    FileUtils.fileExists(existingPkg.getAbsolutePath(), false);
            boolean hasExecutableBootstrapBinaries =
                hasRequiredBootstrapBinaries && existingShell.canExecute() && existingPkg.canExecute();

            if (TermuxFileUtils.isTermuxPrefixDirectoryEmpty()) {
                Logger.logInfo(LOG_TAG, "The termux prefix directory \"" + TERMUX_PREFIX_DIR_PATH + "\" exists but is empty or only contains specific unimportant files.");
            } else if (!hasRequiredBootstrapBinaries) {
                Logger.logWarn(LOG_TAG, "The termux prefix directory \"" + TERMUX_PREFIX_DIR_PATH +
                    "\" exists but is missing required bootstrap binaries. Reinstalling bootstrap.");
            } else if (!hasExecutableBootstrapBinaries) {
                Logger.logWarn(LOG_TAG, "The termux prefix directory \"" + TERMUX_PREFIX_DIR_PATH +
                    "\" exists but required bootstrap binaries are not executable. Reinstalling bootstrap.");
            } else {
                whenDone.run();
                return;
            }
'''
    replace_once(INSTALLER, old, new, "installer existing prefix executable contract")


def patch_session_null_safe_directory_checks() -> None:
    old = '''    private static boolean isUsableDirectory(@NonNull File candidate) {
        return candidate.isDirectory() && candidate.canRead() && candidate.canExecute();
    }

    private static void hardenSystemShellFallbackEnvironment(@NonNull HashMap<String, String> environment,
                                                            @NonNull String workingDirectory) {
'''
    new = '''    private static boolean isUsableDirectory(@NonNull File candidate) {
        return candidate.isDirectory() && candidate.canRead() && candidate.canExecute();
    }

    private static boolean isUsableDirectory(@Nullable String path) {
        return path != null && !path.isEmpty() && isUsableDirectory(new File(path));
    }

    private static void hardenSystemShellFallbackEnvironment(@NonNull HashMap<String, String> environment,
                                                            @NonNull String workingDirectory) {
'''
    replace_once(SESSION, old, new, "session null-safe directory helper")

    old_env = '''        if (!isUsableDirectory(new File(environment.get(UnixShellEnvironment.ENV_TMPDIR))))
            environment.put(UnixShellEnvironment.ENV_TMPDIR, workingDirectory);
        if (!isUsableDirectory(new File(environment.get(UnixShellEnvironment.ENV_HOME))))
            environment.put(UnixShellEnvironment.ENV_HOME, workingDirectory);
'''
    new_env = '''        if (!isUsableDirectory(environment.get(UnixShellEnvironment.ENV_TMPDIR)))
            environment.put(UnixShellEnvironment.ENV_TMPDIR, workingDirectory);
        if (!isUsableDirectory(environment.get(UnixShellEnvironment.ENV_HOME)))
            environment.put(UnixShellEnvironment.ENV_HOME, workingDirectory);
'''
    replace_once(SESSION, old_env, new_env, "session fallback env null-safety")


def main() -> int:
    patch_activity_storage_gate()
    patch_installer_existing_prefix_exec_contract()
    if SESSION.exists():
        patch_session_null_safe_directory_checks()
    print("[boot-hotfix] complete")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
