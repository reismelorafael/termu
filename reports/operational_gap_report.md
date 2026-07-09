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
- **`apt`** — estado: `TOKEN_VAZIO`; evidência: script bridge bootstrap; lacuna: backend real
- **`apt-get`** — estado: `TOKEN_VAZIO`; evidência: script bridge bootstrap; lacuna: backend real
- **`dpkg`** — estado: `TOKEN_VAZIO`; evidência: requisito de payload core; lacuna: binário real
- **`libapt`** — estado: `TOKEN_VAZIO`; evidência: requisito de payload core; lacuna: bibliotecas reais
- **`proot`** — estado: `TOKEN_VAZIO`; evidência: bridge/wrapper; lacuna: `proot.real` ou equivalente
- **certificados** — estado: `TOKEN_VAZIO`; evidência: requisito de payload core; lacuna: CA bundle real
- **DNS/network básico** — estado: `TOKEN_VAZIO`; evidência: requisito de payload core; lacuna: resolver funcional e teste rede
- **repositório configurado** — estado: `TOKEN_VAZIO`; evidência: requisito de payload core; lacuna: `sources.list`/config real

## RISCO

- **bootstrap instala** — risco operacional: teste real em device
- **`sh`** — risco operacional: validar no device
- **`pkg`** — risco operacional: backend real
- **`apt`** — risco operacional: backend real
- **`apt-get`** — risco operacional: backend real
- **`proot`** — risco operacional: `proot.real` ou equivalente
- **DNS/network básico** — risco operacional: resolver funcional e teste rede
- **device smoke** — risco operacional: `DEVICE_SMOKE_REQUIRED=true` em CI real

## PRÓXIMO PASSO

- **release assinado** — segredo oficial no ambiente
- **bootstrap instala** — teste real em device
- **`sh`** — validar no device
- **`pkg`** — backend real
- **`apt`** — backend real
- **`apt-get`** — backend real
- **`dpkg`** — binário real
- **`libapt`** — bibliotecas reais
- **`busybox`** — busybox real ou substituto consistente
- **`proot`** — `proot.real` ou equivalente
- **certificados** — CA bundle real
- **DNS/network básico** — resolver funcional e teste rede
- **repositório configurado** — `sources.list`/config real
- **`pkg update`** — teste real bloqueante
- **`pkg install`** — instalar nano/python/git
- **RAFAELIA JNI** — benchmark
- **CTI** — teste com arquivos grandes
- **ZIPRAF** — documentação clara; não é compressão
- **VCPU** — falta VM completa
- **device smoke** — `DEVICE_SMOKE_REQUIRED=true` em CI real
