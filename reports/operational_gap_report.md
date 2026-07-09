# Operational Gap Report

Gerado a partir de `docs/RUNTIME_TRUTH_TABLE.md`.

## PROVADO

- **APK build** — estado: `PROVADO`; evidência: Gradle/CI; `scripts/build_apk_matrix.sh`; lacuna: —
- **release assinado** — estado: `PROVADO`; evidência: `./gradlew verifyReleaseContract`; lacuna: segredo oficial no ambiente
- **RAFAELIA JNI** — estado: `PROVADO ESTRUTURAL`; evidência: C/JNI; lacuna: benchmark
- **CTI** — estado: `PROVADO ESTRUTURAL`; evidência: C scanner; lacuna: teste com arquivos grandes
- **ZIPRAF** — estado: `PROVADO ESTRUTURAL`; evidência: manifesto; lacuna: documentação clara; não é compressão
- **VCPU** — estado: `PROVADO ESTRUTURAL`; evidência: C state machine; lacuna: falta VM completa

## PARCIAL

- **bootstrap instala** — estado: `PARCIAL`; evidência: `TermuxInstaller` com staging/rollback; lacuna: teste real em device
- **`sh`** — estado: `PARCIAL`; evidência: bootstrap/wrapper; lacuna: validar no device
- **`busybox`** — estado: `PARCIAL`; evidência: wrapper/delegação para toybox/toolbox quando possível; lacuna: busybox real ou substituto consistente
- **device smoke** — estado: `PARCIAL`; evidência: `scripts/device_runtime_smoke.sh`; lacuna: `DEVICE_SMOKE_REQUIRED=true` em CI real

## TOKEN_VAZIO

- **`pkg`** — estado: `TOKEN_VAZIO`; evidência: script bridge bootstrap; lacuna: backend real
- **`apt`** — estado: `TOKEN_VAZIO`; evidência: gerador ARM real criado (`scripts/build_real_arm_bootstrap_core.py`), sem device `pkg update` ainda; lacuna: backend real validado em device
- **`apt-get`** — estado: `TOKEN_VAZIO`; evidência: gerador ARM real criado (`scripts/build_real_arm_bootstrap_core.py`), sem device `pkg update` ainda; lacuna: backend real validado em device
- **`dpkg`** — estado: `TOKEN_VAZIO`; evidência: gerador ARM real criado (`scripts/build_real_arm_bootstrap_core.py`), sem device package install ainda; lacuna: binário real validado em device
- **`libapt`** — estado: `TOKEN_VAZIO`; evidência: dependency closure for `apt` inclui bibliotecas libapt, sem dynamic-link em device ainda; lacuna: teste dynamic-link em device
- **`proot`** — estado: `TOKEN_VAZIO`; evidência: generator renames real Termux `proot` to `bin/proot.real` and emits `bin/proot` shim, sem device ainda; lacuna: `proot --version` on device
- **certificados** — estado: `TOKEN_VAZIO`; evidência: generator includes `ca-certificates` package, sem TLS em device ainda; lacuna: TLS/package update on device
- **DNS/network básico** — estado: `TOKEN_VAZIO`; evidência: generator writes guarded `etc/resolv.conf`, sem rede em device ainda; lacuna: network test on device
- **repositório configurado** — estado: `TOKEN_VAZIO`; evidência: generator writes `etc/apt/sources.list` for Termux main, sem `apt update` em device ainda; lacuna: `apt update` on device

## RISCO

- **bootstrap instala** — risco operacional: teste real em device
- **`sh`** — risco operacional: validar no device
- **`pkg`** — risco operacional: backend real
- **`apt`** — risco operacional: backend real validado em device
- **`apt-get`** — risco operacional: backend real validado em device
- **`dpkg`** — risco operacional: binário real validado em device
- **`libapt`** — risco operacional: teste dynamic-link em device
- **`proot`** — risco operacional: `proot --version` on device
- **certificados** — risco operacional: TLS/package update on device
- **DNS/network básico** — risco operacional: network test on device
- **repositório configurado** — risco operacional: `apt update` on device
- **device smoke** — risco operacional: `DEVICE_SMOKE_REQUIRED=true` em CI real

## PRÓXIMO PASSO

- **release assinado** — segredo oficial no ambiente
- **bootstrap instala** — teste real em device
- **`sh`** — validar no device
- **`pkg`** — backend real
- **`apt`** — backend real validado em device
- **`apt-get`** — backend real validado em device
- **`dpkg`** — binário real validado em device
- **`libapt`** — teste dynamic-link em device
- **`busybox`** — busybox real ou substituto consistente
- **`proot`** — `proot --version` on device
- **certificados** — TLS/package update on device
- **DNS/network básico** — network test on device
- **repositório configurado** — `apt update` on device
- **`pkg update`** — teste real bloqueante
- **`pkg install`** — instalar nano/python/git
- **RAFAELIA JNI** — benchmark
- **CTI** — teste com arquivos grandes
- **ZIPRAF** — documentação clara; não é compressão
- **VCPU** — falta VM completa
- **device smoke** — `DEVICE_SMOKE_REQUIRED=true` em CI real
