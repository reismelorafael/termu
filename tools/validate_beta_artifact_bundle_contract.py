#!/usr/bin/env python3
"""Validate RAFCODEPHI beta artifact bundle structure.

This validator is intentionally structural. It does not install APKs, run device
benchmarks, claim runtime performance, or validate NEON/SIMD speedups.

It accepts either:
  - a ZIP file path; or
  - an extracted artifact directory.

Exit codes:
  0 = required artifact contract passed
  1 = required artifact contract failed
"""

from __future__ import annotations

import argparse
import hashlib
import os
import sys
import zipfile
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable


REQUIRED_ABIS = ("armeabi-v7a", "arm64-v8a", "x86_64")
OPTIONAL_ABIS = ("x86",)

REQUIRED_TEXT_FILES = (
    "dist/apk-matrix/ARTIFACT_MANIFEST.txt",
    "dist/apk-matrix/SHA256SUMS.txt",
    "dist/apk-matrix/APK_SIZE_REPORT.tsv",
    "dist/apk-matrix/APK_SIZE_DIFF_RELEASE.tsv",
    "docs/BETA_BUILD_REPORT.md",
    "docs/BETA_READINESS_REPORT.md",
    "docs/BETA_BOOTSTRAP_BAREMETAL_GUARD.md",
    "docs/BETA_BOOTSTRAP_BAREMETAL_STATUS.md",
    "out/bootstrap_baremetal_guard_smoke.txt",
)

REQUIRED_UNSIGNED_RELEASE = tuple(
    f"dist/apk-matrix/unsigned/termux-rafcodephi-release-{abi}.apk"
    for abi in REQUIRED_ABIS
)

REQUIRED_SIGNED_RELEASE = tuple(
    f"dist/apk-matrix/signed/termux-rafcodephi-release-{abi}-signed.apk"
    for abi in REQUIRED_ABIS
)

UNIVERSAL_RELEASE = (
    "dist/apk-matrix/unsigned/termux-rafcodephi-release-universal.apk",
    "dist/apk-matrix/signed/termux-rafcodephi-release-universal-signed.apk",
)


@dataclass(frozen=True)
class Entry:
    name: str
    size: int
    data: bytes | None = None


class ArtifactReader:
    def names(self) -> set[str]:
        raise NotImplementedError

    def read_bytes(self, name: str) -> bytes:
        raise NotImplementedError

    def size(self, name: str) -> int:
        raise NotImplementedError


class ZipArtifactReader(ArtifactReader):
    def __init__(self, path: Path) -> None:
        self.path = path
        self.zf = zipfile.ZipFile(path)
        self._info = {info.filename: info for info in self.zf.infolist()}

    def names(self) -> set[str]:
        return set(self._info)

    def read_bytes(self, name: str) -> bytes:
        return self.zf.read(name)

    def size(self, name: str) -> int:
        return self._info[name].file_size


class DirectoryArtifactReader(ArtifactReader):
    def __init__(self, path: Path) -> None:
        self.path = path
        self._names: set[str] = set()
        for root, _, files in os.walk(path):
            for filename in files:
                full = Path(root) / filename
                self._names.add(full.relative_to(path).as_posix())

    def names(self) -> set[str]:
        return set(self._names)

    def read_bytes(self, name: str) -> bytes:
        return (self.path / name).read_bytes()

    def size(self, name: str) -> int:
        return (self.path / name).stat().st_size


def make_reader(path: Path) -> ArtifactReader:
    if path.is_file() and zipfile.is_zipfile(path):
        return ZipArtifactReader(path)
    if path.is_dir():
        return DirectoryArtifactReader(path)
    raise ValueError(f"unsupported artifact path: {path}")


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def parse_sha256s(text: str) -> dict[str, str]:
    out: dict[str, str] = {}
    for line in text.splitlines():
        line = line.strip()
        if not line:
            continue
        parts = line.split(None, 1)
        if len(parts) != 2:
            continue
        digest, rel = parts
        out[rel.strip()] = digest.strip().lower()
    return out


def require_present(reader: ArtifactReader, required: Iterable[str], errors: list[str]) -> None:
    names = reader.names()
    for item in required:
        if item not in names:
            errors.append(f"missing required artifact: {item}")
        elif reader.size(item) <= 0:
            errors.append(f"empty required artifact: {item}")


def validate_sha256s(reader: ArtifactReader, errors: list[str], warnings: list[str]) -> None:
    sums_path = "dist/apk-matrix/SHA256SUMS.txt"
    if sums_path not in reader.names():
        errors.append("missing SHA256SUMS.txt")
        return

    sums = parse_sha256s(reader.read_bytes(sums_path).decode("utf-8", "replace"))
    if not sums:
        errors.append("SHA256SUMS.txt has no parseable entries")
        return

    for rel, expected in sorted(sums.items()):
        archive_path = f"dist/apk-matrix/{rel}"
        if archive_path not in reader.names():
            errors.append(f"checksum entry missing artifact: {rel}")
            continue
        actual = sha256_bytes(reader.read_bytes(archive_path))
        if actual != expected:
            errors.append(f"checksum mismatch: {rel}")

    signed_required = [
        f"signed/termux-rafcodephi-release-{abi}-signed.apk" for abi in REQUIRED_ABIS
    ]
    for rel in signed_required:
        if rel not in sums:
            errors.append(f"missing signed release checksum entry: {rel}")

    for rel in (f"unsigned/termux-rafcodephi-release-{abi}.apk" for abi in REQUIRED_ABIS):
        if rel not in sums:
            errors.append(f"missing unsigned release checksum entry: {rel}")

    for abi in OPTIONAL_ABIS:
        rel = f"signed/termux-rafcodephi-release-{abi}-signed.apk"
        if rel not in sums:
            warnings.append(f"optional signed checksum absent: {rel}")


def classify_pss3(reader: ArtifactReader, warnings: list[str]) -> str:
    names = reader.names()
    if "out/failure_trace.csv" in names:
        return "PSS3_AUDIT_INPUT_PRESENT"
    report = "out/pss3_failure_report.txt"
    if report in names:
        txt = reader.read_bytes(report).decode("utf-8", "replace")
        if "failure_trace.csv absent" in txt:
            warnings.append("PSS3 audit classified as TOKEN_VAZIO_INPUT: failure_trace.csv absent")
            return "TOKEN_VAZIO_INPUT"
    warnings.append("PSS3 audit input not found and no explicit absence report found")
    return "TOKEN_VAZIO_INPUT"


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("artifact", type=Path, help="ZIP artifact bundle or extracted artifact directory")
    parser.add_argument("--strict-optional-x86", action="store_true", help="require optional x86 release artifacts")
    args = parser.parse_args(argv)

    errors: list[str] = []
    warnings: list[str] = []

    try:
        reader = make_reader(args.artifact)
    except Exception as exc:  # noqa: BLE001 - CLI validator reports user-facing error
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1

    require_present(reader, REQUIRED_TEXT_FILES, errors)
    require_present(reader, REQUIRED_UNSIGNED_RELEASE, errors)
    require_present(reader, REQUIRED_SIGNED_RELEASE, errors)
    require_present(reader, UNIVERSAL_RELEASE, errors)

    if args.strict_optional_x86:
        require_present(
            reader,
            (
                "dist/apk-matrix/unsigned/termux-rafcodephi-release-x86.apk",
                "dist/apk-matrix/signed/termux-rafcodephi-release-x86-signed.apk",
            ),
            errors,
        )

    validate_sha256s(reader, errors, warnings)
    pss3_state = classify_pss3(reader, warnings)

    print("beta_artifact_contract=PASS" if not errors else "beta_artifact_contract=FAIL")
    print(f"pss3_state={pss3_state}")
    print(f"required_abis={','.join(REQUIRED_ABIS)}")
    print("claim_boundary=structural_artifact_validation_only")

    for warning in warnings:
        print(f"WARNING: {warning}")
    for error in errors:
        print(f"ERROR: {error}", file=sys.stderr)

    return 0 if not errors else 1


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
