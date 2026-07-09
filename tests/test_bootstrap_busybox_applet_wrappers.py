from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BUILD_SCRIPT = ROOT / "scripts/build_rafaelia_bootstraps.sh"
BUILDER = ROOT / "scripts/bootstrap_zip_builder.c"

MINIMUM_DEVICE_COMMANDS = (
    "cat",
    "ls",
    "clear",
    "grep",
    "sed",
    "awk",
    "head",
    "tail",
    "wc",
    "mkdir",
    "rm",
    "cp",
    "mv",
    "ln",
    "chmod",
    "pwd",
    "env",
    "which",
    "find",
    "tar",
    "gzip",
    "gunzip",
    "zcat",
    "stat",
    "strings",
    "file",
    "whoami",
)


def test_busybox_bridge_requires_explicit_applet_and_wrappers_supply_it() -> None:
    source = BUILD_SCRIPT.read_text(encoding="utf-8")

    assert "busybox bridge requires an applet name" in source
    assert "write_busybox_applet_wrapper" in source
    assert 'exec "\\${PREFIX}/bin/busybox" "${app}" "\\$@"' in source
    assert 'exec /system/bin/toybox "${app}" "\\$@"' in source

    for command in MINIMUM_DEVICE_COMMANDS:
        assert command in source


def test_busybox_bridge_uses_absolute_android_tools_without_prefix_recursion() -> None:
    source = BUILD_SCRIPT.read_text(encoding="utf-8")

    assert "exec /system/bin/toybox \"$applet\" \"$@\"" in source
    assert "exec /system/bin/toolbox \"$applet\" \"$@\"" in source
    assert "exec /system/bin/\"$applet\" \"$@\"" in source
    assert "exec /system/xbin/\"$applet\" \"$@\"" in source
    assert 'command -v "$applet"' not in source


def test_zip_builder_makes_command_wrappers_installable_entries() -> None:
    source = BUILDER.read_text(encoding="utf-8")

    assert "command_wrapper_names" in source
    assert "wrapper_paths" in source
    assert "load_file(payload_root,wrapper_paths[i],wrapper_bufs[i],&wrapper_sizes[i])" in source
    assert "EXPLICIT_APPLET_WRAPPERS_READY=1" in source
    assert "BOOTSTRAP_EXPLICIT_APPLET_WRAPPERS=1" in source

    for command in MINIMUM_DEVICE_COMMANDS:
        assert f'"{command}"' in source
        assert f"bin/{command}" in source or "wrapper_paths" in source


def test_compat_hotfix_validates_real_device_minimum_commands() -> None:
    source = BUILDER.read_text(encoding="utf-8")

    for token in (
        'check \\"$PREFIX/bin/cat\\"',
        'check \\"$PREFIX/bin/ls\\"',
        'check \\"$PREFIX/bin/clear\\"',
        'check \\"$PREFIX/bin/grep\\"',
        '\\"$PREFIX/bin/cat\\" --help',
        '\\"$PREFIX/bin/ls\\" \\"$PREFIX/bin\\"',
        '\\"$PREFIX/bin/grep\\" x /dev/null',
    ):
        assert token in source
