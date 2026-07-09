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


def write_reports(hits: list[Hit], max_depth: int) -> None:
    REPORT_JSON.write_text(
        json.dumps(
            {
                "max_depth": max_depth,
                "hit_count": len(hits),
                "hits_sample_limit": MAX_JSON_HITS,
                "hits_sample": [asdict(hit) for hit in hits[:MAX_JSON_HITS]],
                "falsification": "Audit is stale if new source files are added beyond the bounded scan or runtime tests contradict structural markers.",
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
    write_reports(hits, args.max_depth)
    print(f"operational_stub_audit=PASS max_depth={args.max_depth} hits={len(hits)}")
    print(f"report_md={REPORT_MD.relative_to(ROOT)}")
    print(f"report_json={REPORT_JSON.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
