# REAL_PKG_CORE_BOOTSTRAP_IMPLEMENTATION

## Correção

O build do bootstrap não pode parar em `pkg help`. Para ARM, o fluxo agora tenta gerar payload real por padrão:

```bash
RAFCODEPHI_REAL_PKG_BOOTSTRAP=true bash scripts/build_rafaelia_bootstraps.sh
```

Esse comando primeiro gera os zips bridge para todos os ABIs e depois sobrescreve:

```text
app/src/main/cpp/rewritten-bootstrap-aarch64.zip
app/src/main/cpp/rewritten-bootstrap-arm.zip
```

com payload real gerado por:

```bash
python3 scripts/build_real_arm_bootstrap_core.py --arch all
```

## Conteúdo mínimo do payload ARM real

O gerador baixa pacotes `.deb` reais do Termux, verifica SHA-256, extrai o fechamento de dependências e monta prefixo RAFCODEPHI com:

```text
apt
apt-get
dpkg
pkg
bash
busybox
coreutils
findutils
grep
sed
gawk
tar
gzip
ncurses-utils
ca-certificates
proot/proot.real
termux-tools
sources.list
resolv.conf
```

## Fallbacks

Se algum comando mínimo não existir como binário real, o gerador cria wrapper executável que chama:

```sh
$PREFIX/bin/busybox <applet> "$@"
```

com fallback para Android toybox/toolbox.

## Gate

O build agora valida os zips ARM reais com:

```bash
python3 scripts/validate_real_arm_bootstrap_core.py \
  app/src/main/cpp/rewritten-bootstrap-aarch64.zip \
  app/src/main/cpp/rewritten-bootstrap-arm.zip
```

Se a auditoria detectar `LEGACY_PREFIX_BINARY_RISK`, o build falha. Melhor falhar o beta do que entregar APK com `pkg` falso.

## Prova final

O estado `pkg real` só vira PROVADO quando passar no aparelho:

```bash
REQUIRE_REAL_PKG=true ./scripts/device_pkg_smoke.sh
```

## Veredito

F_ok: build ARM agora tenta payload real por padrão.

F_gap: device smoke ainda é necessário para declarar `pkg update/install` provado.

F_next: CI gerar os zips reais; se `LEGACY_PREFIX_BINARY_RISK` aparecer, rebuild de pacotes RAFCODEPHI ou estratégia compatível é obrigatório.
