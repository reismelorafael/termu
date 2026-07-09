#!/usr/bin/env python3
from __future__ import annotations
import sys, zipfile
from pathlib import Path

REQUIRED = (
    'bin/sh', 'bin/bash', 'bin/apt', 'bin/apt-get', 'bin/dpkg', 'bin/pkg',
    'bin/proot', 'bin/proot.real', 'bin/cat', 'bin/ls', 'bin/clear', 'bin/grep',
    'etc/apt/sources.list', 'etc/resolv.conf', 'etc/rafcodephi-core.env',
    'BOOTSTRAP_INFO', 'SYMLINKS.txt'
)
PREFIX = '/data/data/com.termux.rafacodephi/files/usr'
LEGACY_PREFIXES = (
    b'/data/data/com.termux/files/usr',
    b'/data/data/com.termux/',
)
BINARY_RISK = 'LEGACY_PREFIX_BINARY_RISK'


def decode_utf8(data: bytes) -> str | None:
    if b'\x00' in data:
        return None
    try:
        return data.decode('utf-8')
    except UnicodeDecodeError:
        return None


def classify_legacy_prefix(path: Path, entry: str, data: bytes) -> list[str]:
    errors: list[str] = []
    found = [prefix for prefix in LEGACY_PREFIXES if prefix in data]
    if not found:
        return errors
    text = decode_utf8(data)
    for prefix in found:
        legacy = prefix.decode('utf-8')
        if text is None:
            errors.append(
                f'{path}: {BINARY_RISK}: entry={entry} legacy_prefix={legacy} '
                'recommendation=rebuild package with RAFCODEΦ prefix or use a safe compatibility strategy; no binary replacement was performed'
            )
        else:
            errors.append(f'{path}: legacy prefix in text entry={entry} legacy_prefix={legacy}')
    return errors


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
        for token in [
            'BOOTSTRAP_REAL_APT_READY=1',
            'BOOTSTRAP_REAL_DPKG_READY=1',
            'BOOTSTRAP_REAL_PROOT_READY=1',
            'BOOTSTRAP_REAL_COREUTILS_READY=1',
            'BOOTSTRAP_CA_CERTIFICATES_READY=1',
            'BOOTSTRAP_DNS_RESOLVER_READY=1',
            'BOOTSTRAP_MINIMUM_COMMANDS_READY=1',
        ]:
            if token not in info:
                errors.append(f'{path}: missing info token {token}')
        for name in names:
            if name.startswith('/') or '..' in name.split('/'):
                errors.append(f'{path}: unsafe zip entry {name}')
        for name in names:
            if name.endswith('/'):
                continue
            data = zf.read(name)
            errors.extend(classify_legacy_prefix(path, name, data))
        text_names=[n for n in names if n.endswith(('.list','.env','.sh')) or n in ('bin/pkg','bin/proot','bin/cat','bin/ls','bin/clear','bin/grep','etc/resolv.conf')]
        for name in text_names:
            data=zf.read(name)
            text=decode_utf8(data)
            if text is None:
                continue
            if name in ('etc/rafcodephi-core.env','bin/proot','bin/cat','bin/ls','bin/clear','bin/grep') and PREFIX not in text:
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
