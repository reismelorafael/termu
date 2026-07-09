# PKG_REAL_PR_BODY

## Escopo

Este PR não promete `apt` real por texto. Ele cria o **contrato executável** para transformar `pkg` real em prova reproduzível.

## Três níveis

1. `pkg help`: camada mínima, depende de wrappers básicos.
2. `pkg bridge`: estado atual quando o backend real ainda não existe.
3. `pkg real`: estado permitido somente com `DEVICE_REAL_PKG_VALIDATED`.

## Gate

```bash
REQUIRE_REAL_PKG=true ./scripts/device_pkg_smoke.sh
```

Esse gate executa:

```bash
pkg update -y
pkg install -y nano
nano --version
pkg install -y python
python --version
pkg install -y git
git --version
```

## Saídas

```text
reports/device_pkg_smoke.json
reports/device_pkg_smoke.md
reports/device_pkg_smoke.log
```

## Frase de corte

Sem `DEVICE_REAL_PKG_VALIDATED`, `pkg update/install` permanece `TOKEN_VAZIO`.
