# REAL_PKG_PROMOTION_CONTRACT

## Objetivo

Separar três estados que antes ficavam misturados:

| Estado | Significado |
|---|---|
| `pkg help` | o wrapper responde e comandos mínimos existem |
| `pkg bridge` | `pkg` ainda depende de backend `apt/apt-get` real |
| `pkg real` | `pkg update` e `pkg install` funcionam em device |

## Estado atual

Depois do contrato de wrappers, o bootstrap mínimo pode validar:

```sh
cat --help
ls "$HOME"
clear
grep x /dev/null
pkg help
apt help
```

Isso prova apenas:

```text
DEVICE_MINIMAL_PKG_LAYER_VALIDATED
```

Não prova `pkg update` nem `pkg install`.

## Caminho para ter `pkg` real

O pacote real precisa de payload core com:

```text
apt
apt-get
dpkg
libapt
bash
busybox
termux-tools
ca-certificates
sources.list
resolv.conf
```

O gerador estrutural já existe:

```sh
./scripts/build_real_arm_bootstrap_core.py --arch all
```

A validação estrutural obrigatória:

```sh
python3 scripts/validate_real_arm_bootstrap_core.py \
  app/src/main/cpp/rewritten-bootstrap-aarch64.zip \
  app/src/main/cpp/rewritten-bootstrap-arm.zip
```

Qualquer `LEGACY_PREFIX_BINARY_RISK` bloqueia promoção.

## Gate real em device

Para promover `pkg` de `TOKEN_VAZIO` para `PROVADO`, rode:

```sh
REQUIRE_REAL_PKG=true ./scripts/device_pkg_smoke.sh
```

Esse gate executa em device:

```sh
pkg update -y
pkg install -y nano
nano --version
pkg install -y python
python --version
pkg install -y git
git --version
```

Promoção só é permitida quando o relatório declarar:

```text
DEVICE_REAL_PKG_VALIDATED
```

## Artefatos esperados

```text
reports/device_pkg_smoke.json
reports/device_pkg_smoke.md
reports/device_pkg_smoke.log
```

## Limite honesto

Enquanto o resultado for apenas:

```text
DEVICE_MINIMAL_PKG_LAYER_VALIDATED
```

então o sistema tem `pkg help`, mas não tem `pkg` real.

## Veredito

F_ok: contrato de promoção criado.

F_gap: payload core real ainda precisa passar por device smoke.

F_next: gerar APK com payload real, instalar no device e rodar `REQUIRE_REAL_PKG=true ./scripts/device_pkg_smoke.sh`.
