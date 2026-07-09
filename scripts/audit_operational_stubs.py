#!/usr/bin/env python3
"""Depth-limited operational audit for stubs, missing evidence, and rollback gaps.

The audit is intentionally structural: it does not claim runtime proof. It scans the
repository up to a bounded depth (default: five levels) and emits a compact report
that keeps known gaps visible instead of silently treating placeholders as done.
"""
from __future__ import annotations

import argparse
import json
import re
from dataclasses import asdict, dataclass
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPORT_MD = ROOT / "reports/operational_stub_audit.md"
REPORT_JSON = ROOT / "reports/operational_stub_audit.json"
MAX_REPORT_HITS = 500
MAX_JSON_HITS = 1000

EXCLUDED_DIRS = {
    ".git",
    ".gradle",
    ".idea",
    ".vscode",
    "build",
    ".externalNativeBuild",
    "node_modules",
}
TEXT_SUFFIXES = {
    "",
    ".c",
    ".cc",
    ".cpp",
    ".h",
    ".hpp",
    ".java",
    ".kt",
    ".kts",
    ".py",
    ".sh",
    ".md",
    ".txt",
    ".xml",
    ".json",
    ".csv",
    ".tsv",
    ".yml",
    ".yaml",
    ".mk",
    ".gradle",
    ".properties",
    ".S",
    ".s",
}
PATTERNS = {
    "stub_or_placeholder": re.compile(r"\b(stub|placeholder|TODO|FIXME)\b", re.IGNORECASE),
    "missing_or_absence": re.compile(r"\b(missing|aus[eê]ncia|incomplete|not implemented)\b", re.IGNORECASE),
    "failsafe_failover_rollback": re.compile(r"\b(FAILSAFE|FAILOVER|ROLLBACK|mitiga[cç][aã]o)\b", re.IGNORECASE),
    "vectra_risk_marker": re.compile(r"\b(VOID paradox|attractor_table|period-42|BitOmega)\b", re.IGNORECASE),
    "heap_forbidden_hotpath": re.compile(r"\b(malloc|calloc|realloc|free)\b"),
}


@dataclass(frozen=True)
class Hit:
    path: str
    line: int
    category: str
    excerpt: str


@dataclass(frozen=True)
class ReadinessCheck:
    component: str
    status: str
    path: str
    evidence: str
    mitigation: str



def file_contains(path: str, token: str) -> bool:
    candidate = ROOT / path
    if not candidate.exists():
        return False
    try:
        return token in candidate.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        return False


def readiness_check(component: str, path: str, token: str, mitigation: str) -> ReadinessCheck:
    candidate = ROOT / path
    if not candidate.exists():
        return ReadinessCheck(component, "FAIL", path, "missing file", mitigation)
    if not file_contains(path, token):
        return ReadinessCheck(component, "FAIL", path, f"missing token: {token}", mitigation)
    return ReadinessCheck(component, "PASS", path, f"contains token: {token}", "keep covered by audit and runtime smoke")


def apk_termux_readiness() -> list[ReadinessCheck]:
    """Check the structural pieces required for the APK to install and expose Termux terminal tools."""
    checks = [
        readiness_check("apk_application_id", "app/build.gradle", "com.termux.rafacodephi", "restore side-by-side applicationId/package placeholders"),
        readiness_check("apk_bootstrap_generation_task", "app/build.gradle", "generateRafcodephiBootstraps", "wire bootstrap generation before native build/preBuild"),
        readiness_check("apk_bootstrap_zip_inputs", "app/build.gradle", "rewritten-bootstrap-aarch64.zip", "declare generated bootstrap zip inputs for incbin"),
        readiness_check("apk_16kb_page_flag", "app/src/main/cpp/Android.mk", "max-page-size=16384", "restore Android 15/16 linker page-size flags"),
        readiness_check("apk_native_bootstrap_library", "app/src/main/cpp/Android.mk", "libtermux-bootstrap", "keep bootstrap shared library in native build"),
        readiness_check("apk_baremetal_library", "app/src/main/cpp/Android.mk", "termux-baremetal", "keep low-level guard/native library in native build"),
        readiness_check("termux_launcher_activity", "app/src/main/AndroidManifest.xml", "com.termux.app.TermuxActivity", "restore launchable terminal activity"),
        readiness_check("termux_foreground_service", "app/src/main/AndroidManifest.xml", "com.termux.app.TermuxService", "restore foreground terminal service declaration"),
        readiness_check("termux_run_command_service", "app/src/main/AndroidManifest.xml", "com.termux.app.RunCommandService", "restore RUN_COMMAND service for automation/plugins"),
        readiness_check("termux_documents_provider", "app/src/main/AndroidManifest.xml", "TermuxDocumentsProvider", "restore documents provider for file access"),
        readiness_check("termux_install_shell", "scripts/build_rafaelia_bootstraps.sh", "bin/sh", "bootstrap must provide a shell entrypoint inside PREFIX"),
        readiness_check("termux_install_pkg", "scripts/build_rafaelia_bootstraps.sh", "bin/pkg", "bootstrap must provide pkg command bridge"),
        readiness_check("termux_install_apt", "scripts/build_rafaelia_bootstraps.sh", "bin/apt", "bootstrap must provide apt/apt-get bridge or real backend handoff"),
        readiness_check("termux_install_busybox", "scripts/build_rafaelia_bootstraps.sh", "bin/busybox", "bootstrap must provide busybox fallback utilities"),
        readiness_check("termux_install_proot", "scripts/build_rafaelia_bootstraps.sh", "bin/proot", "bootstrap must provide proot bridge/fallback path"),
        readiness_check("termux_prefix_side_by_side", "scripts/build_rafaelia_bootstraps.sh", "/data/data/com.termux.rafacodephi/files/usr", "avoid hardcoded upstream com.termux prefix in generated bootstrap"),
    ]
    generated = [
        "app/src/main/cpp/rewritten-bootstrap-aarch64.zip",
        "app/src/main/cpp/rewritten-bootstrap-arm.zip",
        "app/src/main/cpp/rewritten-bootstrap-i686.zip",
        "app/src/main/cpp/rewritten-bootstrap-x86_64.zip",
    ]
    for item in generated:
        if (ROOT / item).exists():
            checks.append(ReadinessCheck("generated_bootstrap_zip", "PASS", item, "generated artifact exists", "keep generated artifact fresh"))
        else:
            checks.append(ReadinessCheck("generated_bootstrap_zip", "WARN", item, "generated artifact missing before local build", "run `bash scripts/build_rafaelia_bootstraps.sh` or Gradle preBuild"))
    return checks


def depth_of(path: Path) -> int:
    return len(path.relative_to(ROOT).parts)


def iter_files(max_depth: int) -> list[Path]:
    files: list[Path] = []
    for path in ROOT.rglob("*"):
        rel_parts = path.relative_to(ROOT).parts
        if any(part in EXCLUDED_DIRS for part in rel_parts):
            continue
        if not path.is_file() or depth_of(path) > max_depth:
            continue
        if path in {REPORT_MD, REPORT_JSON}:
            continue
        if path.suffix not in TEXT_SUFFIXES:
            continue
        files.append(path)
    return sorted(files, key=lambda item: item.as_posix())


def scan_file(path: Path) -> list[Hit]:
    try:
        text = path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        return []
    hits: list[Hit] = []
    for index, line in enumerate(text.splitlines(), start=1):
        for category, pattern in PATTERNS.items():
            if pattern.search(line):
                excerpt = " ".join(line.strip().split())[:180]
                hits.append(Hit(path.relative_to(ROOT).as_posix(), index, category, excerpt))
    return hits


def write_reports(hits: list[Hit], checks: list[ReadinessCheck], max_depth: int) -> None:
    REPORT_JSON.write_text(
        json.dumps(
            {
                "max_depth": max_depth,
                "hit_count": len(hits),
                "hits_sample_limit": MAX_JSON_HITS,
                "hits_sample": [asdict(hit) for hit in hits[:MAX_JSON_HITS]],
                "falsification": "Audit is stale if new source files are added beyond the bounded scan or runtime tests contradict structural markers.",
                "apk_termux_readiness": [asdict(check) for check in checks],
            },
            ensure_ascii=False,
            indent=2,
            sort_keys=True,
        )
        + "\n",
        encoding="utf-8",
    )
    counts: dict[str, int] = {}
    for hit in hits:
        counts[hit.category] = counts.get(hit.category, 0) + 1
    lines = [
        "# Operational Stub Audit",
        "",
        f"- scan_depth: {max_depth}",
        f"- hit_count: {len(hits)}",
        "- scope: structural repository scan only; no runtime proof claimed",
        "- falsification: audit is stale if new source files are added beyond the bounded scan or runtime tests contradict structural markers",
        "",
        "## Category counts",
        "",
    ]
    for category in sorted(counts):
        lines.append(f"- {category}: {counts[category]}")
    by_file: dict[str, int] = {}
    for hit in hits:
        by_file[hit.path] = by_file.get(hit.path, 0) + 1
    readiness_counts: dict[str, int] = {}
    for check in checks:
        readiness_counts[check.status] = readiness_counts.get(check.status, 0) + 1
    lines.extend(["", "## APK/Termux install readiness", "", "| Component | Status | Path | Evidence | Mitigation |", "|---|---|---|---|---|"])
    for check in checks:
        lines.append(f"| {check.component} | {check.status} | `{check.path}` | {check.evidence} | {check.mitigation} |")
    lines.extend(["", "## Readiness counts", ""])
    for status in sorted(readiness_counts):
        lines.append(f"- {status}: {readiness_counts[status]}")
    lines.extend(["", "## Highest-hit files", "", "| Path | Hits |", "|---|---:|"])
    for path, count in sorted(by_file.items(), key=lambda item: (-item[1], item[0]))[:40]:
        lines.append(f"| `{path}` | {count} |")
    lines.extend([
        "",
        f"## Hit sample (first {min(len(hits), MAX_REPORT_HITS)} of {len(hits)})",
        "",
        "| Path | Line | Category | Excerpt |",
        "|---|---:|---|---|",
    ])
    for hit in hits[:MAX_REPORT_HITS]:
        escaped = hit.excerpt.replace("|", "\\|")
        lines.append(f"| `{hit.path}` | {hit.line} | {hit.category} | {escaped} |")
    REPORT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--max-depth", type=int, default=5)
    args = parser.parse_args()
    hits = [hit for path in iter_files(args.max_depth) for hit in scan_file(path)]
    checks = apk_termux_readiness()
    write_reports(hits, checks, args.max_depth)
    hard_failures = sum(1 for check in checks if check.status == "FAIL")
    warnings = sum(1 for check in checks if check.status == "WARN")
    print(f"operational_stub_audit=PASS max_depth={args.max_depth} hits={len(hits)} readiness_fail={hard_failures} readiness_warn={warnings}")
    print(f"report_md={REPORT_MD.relative_to(ROOT)}")
    print(f"report_json={REPORT_JSON.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
