#!/usr/bin/env python3
from __future__ import annotations
import sys, zipfile
from pathlib import Path

REQUIRED = (
    'bin/sh', 'bin/bash', 'bin/apt', 'bin/apt-get', 'bin/dpkg', 'bin/pkg',
    'bin/proot', 'bin/proot.real', 'etc/apt/sources.list', 'etc/resolv.conf',
    'etc/rafcodephi-core.env', 'BOOTSTRAP_INFO', 'SYMLINKS.txt'
)
PREFIX = '/data/data/com.termux.rafacodephi/files/usr'

def check(path: Path) -> list[str]:
    errors=[]
    with zipfile.ZipFile(path) as zf:
        names=set(zf.namelist())
        symlink_destinations=set()
        if 'SYMLINKS.txt' in names:
            for line in zf.read('SYMLINKS.txt').decode('utf-8', 'replace').splitlines():
                parts=line.split('←')
                if len(parts) == 2:
                    symlink_destinations.add(parts[1])
        present = names | symlink_destinations
        for req in REQUIRED:
            if req not in present:
                errors.append(f'{path}: missing {req}')
        info=zf.read('BOOTSTRAP_INFO').decode('utf-8', 'replace') if 'BOOTSTRAP_INFO' in names else ''
        for token in ['BOOTSTRAP_REAL_APT_READY=1','BOOTSTRAP_REAL_DPKG_READY=1','BOOTSTRAP_REAL_PROOT_READY=1','BOOTSTRAP_CA_CERTIFICATES_READY=1','BOOTSTRAP_DNS_RESOLVER_READY=1']:
            if token not in info:
                errors.append(f'{path}: missing info token {token}')
        for name in names:
            if name.startswith('/') or '..' in name.split('/'):
                errors.append(f'{path}: unsafe zip entry {name}')
        text_names=[n for n in names if n.endswith(('.list','.env','.sh')) or n in ('bin/pkg','bin/proot','etc/resolv.conf')]
        for name in text_names:
            data=zf.read(name)
            if b'\x00' in data:
                continue
            text=data.decode('utf-8','ignore')
            if '/data/data/com.termux/files/usr' in text:
                errors.append(f'{path}: legacy prefix in {name}')
            if name in ('etc/apt/sources.list','etc/rafcodephi-core.env','bin/proot') and PREFIX not in text and name != 'etc/apt/sources.list':
                errors.append(f'{path}: canonical prefix missing in {name}')
    return errors

def main(argv):
    if not argv:
        print('usage: validate_real_arm_bootstrap_core.py <zip>...', file=sys.stderr); return 2
    errors=[]
    for arg in argv:
        p=Path(arg)
        if not p.exists(): errors.append(f'missing zip: {p}')
        else: errors.extend(check(p))
    if errors:
        print('\n'.join(errors), file=sys.stderr); return 1
    print('real_arm_bootstrap_core=PASS')
    return 0
if __name__ == '__main__':
    raise SystemExit(main(sys.argv[1:]))
