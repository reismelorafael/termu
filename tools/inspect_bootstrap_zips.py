#!/usr/bin/env python3
from __future__ import annotations

import stat
import sys
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CPP = ROOT / "app" / "src" / "main" / "cpp"
ZIPS = (
    "rewritten-bootstrap-aarch64.zip",
    "rewritten-bootstrap-arm.zip",
    "rewritten-bootstrap-i686.zip",
    "rewritten-bootstrap_x86_64.zip".replace("_x86", "-x86"),
)

BRIDGE_REQUIRED = {
    "BOOTSTRAP_INFO",
    "SYMLINKS.txt",
    "BUILD_ONLY",
    "bin/sh",
    "bin/pkg",
    "bin/apt",
    "bin/apt-get",
    "bin/busybox",
    "bin/proot",
    "bin/apkmanager",
    "bin/shellbash",
    "bin/busybox-safe",
    "bin/proot-safe",
    "bin/rafcodephi-compat-hotfix",
    "etc/motd",
}

COMMAND_WRAPPERS = {
    "bin/cat", "bin/ls", "bin/clear", "bin/head", "bin/tail", "bin/grep",
    "bin/sed", "bin/awk", "bin/cut", "bin/tr", "bin/wc", "bin/sort",
    "bin/uniq", "bin/xargs", "bin/tee", "bin/mkdir", "bin/rmdir",
    "bin/rm", "bin/cp", "bin/mv", "bin/ln", "bin/chmod", "bin/chown",
    "bin/chgrp", "bin/uname", "bin/id", "bin/pwd", "bin/env", "bin/dirname",
    "bin/basename", "bin/touch", "bin/test", "bin/printf", "bin/echo",
    "bin/sleep", "bin/date", "bin/dd", "bin/du", "bin/df", "bin/ps",
    "bin/kill", "bin/which", "bin/find", "bin/readlink", "bin/realpath",
    "bin/expr", "bin/yes", "bin/false", "bin/true", "bin/seq", "bin/tar",
    "bin/gzip", "bin/gunzip", "bin/zcat", "bin/stat", "bin/strings",
    "bin/file", "bin/whoami", "bin/hostname", "bin/printenv",
}

REAL_REQUIRED = {
    "BOOTSTRAP_INFO",
    "SYMLINKS.txt",
    "bin/sh",
    "bin/bash",
    "bin/apt",
    "bin/apt-get",
    "bin/dpkg",
    "bin/pkg",
    "bin/proot",
    "bin/proot.real",
    "bin/cat",
    "bin/ls",
    "bin/clear",
    "bin/grep",
    "etc/apt/sources.list",
    "etc/resolv.conf",
    "etc/rafcodephi-core.env",
}

BRIDGE_INFO = (
    "BOOTSTRAP_UTILS_READY=1",
    "BOOTSTRAP_APKMANAGER_READY=1",
    "BOOTSTRAP_SHELLBASH_READY=1",
    "BOOTSTRAP_BUSYBOX_SAFE_READY=1",
    "BOOTSTRAP_PROOT_SAFE_READY=1",
    "BOOTSTRAP_COMPAT_HOTFIX_READY=1",
    "BOOTSTRAP_FULLENGINE_READY=1",
    "BOOTSTRAP_PATHS_VALIDATED=1",
    "BOOTSTRAP_PERMISSIONS_DECLARED=1",
    "BOOTSTRAP_COMMAND_WRAPPERS_READY=1",
    "BOOTSTRAP_EXPLICIT_APPLET_WRAPPERS=1",
)

REAL_INFO = (
    "RAFCODEPHI_BOOTSTRAP=real-arm-core",
    "BOOTSTRAP_REAL_APT_READY=1",
    "BOOTSTRAP_REAL_DPKG_READY=1",
    "BOOTSTRAP_REAL_PROOT_READY=1",
    "BOOTSTRAP_REAL_COREUTILS_READY=1",
    "BOOTSTRAP_CA_CERTIFICATES_READY=1",
    "BOOTSTRAP_DNS_RESOLVER_READY=1",
    "BOOTSTRAP_MINIMUM_COMMANDS_READY=1",
)


def symlink_destinations(zf: zipfile.ZipFile) -> set[str]:
    if "SYMLINKS.txt" not in zf.namelist():
        return set()
    destinations: set[str] = set()
    for line in zf.read("SYMLINKS.txt").decode("utf-8", "replace").splitlines():
        parts = line.split("←")
        if len(parts) == 2:
            destinations.add(parts[1])
    return destinations


def assert_mode(zf: zipfile.ZipFile, name: str) -> None:
    if name not in zf.namelist() or not name.startswith("bin/"):
        return
    mode = (zf.getinfo(name).external_attr >> 16) & 0o7777
    if not (mode & stat.S_IXUSR):
        raise SystemExit(f"{zf.filename}: missing owner execute bit on {name}: mode={mode:o}")


def inspect_zip(path: Path) -> None:
    if not path.is_file():
        raise SystemExit(f"missing generated bootstrap package: {path}")
    with zipfile.ZipFile(path) as zf:
        names = set(zf.namelist())
        for entry in names:
            if entry.startswith("/") or ".." in entry.split("/"):
                raise SystemExit(f"{path.name}: unsafe entry path: {entry}")
        info = zf.read("BOOTSTRAP_INFO").decode("utf-8", "replace") if "BOOTSTRAP_INFO" in names else ""
        present = names | symlink_destinations(zf)
        if "RAFCODEPHI_BOOTSTRAP=real-arm-core" in info:
            required = REAL_REQUIRED
            tokens = REAL_INFO
            kind = "real-arm-core"
        else:
            required = BRIDGE_REQUIRED | COMMAND_WRAPPERS
            tokens = BRIDGE_INFO
            kind = "bridge"
        missing = sorted(required - present)
        if missing:
            raise SystemExit(f"{path.name}: missing {kind} entries: {missing}")
        for token in tokens:
            if token not in info:
                raise SystemExit(f"{path.name}: missing {kind} metadata token {token}")
        for entry in required:
            assert_mode(zf, entry)
        print(f"{path.name}: {kind}=PASS")


def main() -> int:
    for zip_name in ZIPS:
        inspect_zip(CPP / zip_name)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
