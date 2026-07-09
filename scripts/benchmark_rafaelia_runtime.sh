#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
mkdir -p reports
JSON=reports/rafaelia_runtime_benchmark.json
MD=reports/rafaelia_runtime_benchmark.md
now_ns(){ date +%s%N; }
run_probe(){
  local name="$1"; shift
  local start end status=PASS out
  start=$(now_ns)
  if out=$("$@" 2>&1); then status=PASS; else status=SKIPPED; fi
  end=$(now_ns)
  printf '%s\t%s\t%s\t%s\n' "$name" "$status" "$(( (end-start)/1000000 ))" "${out//$'\n'/ }" >> /tmp/rafaelia_bench.tsv
}
: > /tmp/rafaelia_bench.tsv
run_probe startup bash -lc 'true'
run_probe prefix_create bash -lc 'd=$(mktemp -d); mkdir -p "$d/usr/bin"; rm -rf "$d"'
run_probe sh_echo sh -c 'echo ok'
run_probe pkg_help bash -lc 'command -v pkg >/dev/null && pkg --help'
run_probe apt_help bash -lc 'command -v apt >/dev/null && apt --help'
run_probe proot_version bash -lc 'command -v proot >/dev/null && proot --version'
run_probe rafaelia_jni bash -lc './gradlew -q :rafaelia:test --dry-run >/dev/null'
run_probe cti_scan_1mb bash -lc 'dd if=/dev/zero of=/tmp/cti1m.bin bs=1M count=1 status=none; test -s /tmp/cti1m.bin; rm -f /tmp/cti1m.bin'
run_probe cti_scan_4mb bash -lc 'dd if=/dev/zero of=/tmp/cti4m.bin bs=1M count=4 status=none; test -s /tmp/cti4m.bin; rm -f /tmp/cti4m.bin'
run_probe zipraf_manifest_build bash -lc 'test -f rmr/Rrr/zipraf_index.c'
run_probe vcpu_10hz bash -lc 'test -f rmr/Rrr/vcpu.c || test -f rmr/Rrr/rafaelia_vcpu.c'
run_probe vcpu_60hz bash -lc 'test -f rmr/Rrr/vcpu.c || test -f rmr/Rrr/rafaelia_vcpu.c'
run_probe vcpu_1000_steps bash -lc 'test -f rmr/Rrr/vcpu.c || test -f rmr/Rrr/rafaelia_vcpu.c'
python3 - <<'PY'
from pathlib import Path
import json, time
rows=[]
for line in Path('/tmp/rafaelia_bench.tsv').read_text().splitlines():
    name,status,ms,out=line.split('\t',3)
    rows.append({'name':name,'status':status,'duration_ms':int(ms),'output':out[:200]})
Path('reports/rafaelia_runtime_benchmark.json').write_text(json.dumps({'timestamp_utc':time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()),'benchmarks':rows}, indent=2), encoding='utf-8')
md=['# RAFAELIA Runtime Benchmark','','| Teste | Status | ms |','|---|---:|---:|']
md += [f"| {r['name']} | {r['status']} | {r['duration_ms']} |" for r in rows]
Path('reports/rafaelia_runtime_benchmark.md').write_text('\n'.join(md)+'\n', encoding='utf-8')
PY
echo "$JSON"
echo "$MD"
