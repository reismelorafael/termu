# ENGINEERING_RUNBOOK_RAFCODEPHI

Ordem única de execução do ferreiro RAFCODEΦ:

1. `./scripts/validate_side_by_side_contract.py`
2. `./scripts/validate_abi_policy_consistency.sh`
3. `./scripts/bootstrap_lowlevel_sync_check.sh`
4. `./scripts/prepare_bootstrap_env.sh`
5. `./scripts/verify_bootstrap_contract.sh`
6. `./scripts/build_apk_matrix.sh`
7. `./gradlew verifyReleaseContract`
8. `./scripts/device_runtime_smoke.sh`
9. `./scripts/device_pkg_smoke.sh`

## Floresta de hotfixes

A ordem estratégica completa dos hotfixes vive em:

- `docs/HOTFIX_EXECUTION_FOREST.md`

Use esse mapa para decidir o próximo PR sem misturar promessa com prova. Cada hotfix deve manter a sequência:

```text
vetor → lacuna → hotfix → prova mínima → artefato → promoção epistêmica
```

Nada deve sair de `TOKEN_VAZIO` para `PROVADO` sem device real, artefato em `reports/` e comando reproduzível.

## Modo device bloqueante

Para transformar smoke em gate obrigatório:

```bash
DEVICE_SMOKE_REQUIRED=true ./scripts/device_runtime_smoke.sh path/to/app.apk
```

O modo obrigatório falha quando `final_status != DEVICE_VALIDATED`.

## Camada mínima de `pkg`

Antes de afirmar que existe `pkg` operacional, valide a camada mínima no device:

```bash
./scripts/device_pkg_smoke.sh
```

Essa camada exige:

```bash
cat --help
ls "$HOME"
clear
grep x /dev/null
pkg help
apt help
```

Resultado mínimo esperado quando o APK ainda estiver em modo bridge:

```text
DEVICE_MINIMAL_PKG_LAYER_VALIDATED
```

Esse estado prova apenas que `pkg help` não quebra por ausência de comandos básicos. Ele **não** prova `pkg update` nem `pkg install`.

## Payload core ARM real

O build padrão agora tenta gerar payload core real para ARM:

```bash
RAFCODEPHI_REAL_PKG_BOOTSTRAP=true bash scripts/build_rafaelia_bootstraps.sh
```

Esse caminho sobrescreve:

```text
app/src/main/cpp/rewritten-bootstrap-aarch64.zip
app/src/main/cpp/rewritten-bootstrap-arm.zip
```

com payload real contendo `apt`, `apt-get`, `dpkg`, `pkg`, `bash`, `busybox`, `coreutils`, `ca-certificates`, `termux-tools`, DNS e `sources.list`. Os zips i686/x86_64 permanecem em modo bridge até haver payload real equivalente.

Para rodar só o gerador real manualmente:

```bash
./scripts/build_real_arm_bootstrap_core.py --arch all
python3 scripts/validate_real_arm_bootstrap_core.py \
  app/src/main/cpp/rewritten-bootstrap-aarch64.zip \
  app/src/main/cpp/rewritten-bootstrap-arm.zip
DEVICE_SMOKE_REQUIRED=true ./scripts/device_runtime_smoke.sh path/to/app.apk
./scripts/device_pkg_smoke.sh
```

A validação do ZIP é obrigatória antes do device smoke. Falha `LEGACY_PREFIX_BINARY_RISK` bloqueia promoção: ela significa prefix legado dentro de arquivo binário/non-UTF-8, sem replace automático seguro; o pacote afetado deve ser reconstruído com prefix RAFCODEΦ ou coberto por estratégia de compatibilidade segura.

Promoção de `pkg` real permitida somente depois de passar, em dispositivo real:

```bash
REQUIRE_REAL_PKG=true ./scripts/device_pkg_smoke.sh
```

Esse gate executa:

1. `pkg update -y`
2. `pkg install -y nano`
3. `nano --version`
4. `pkg install -y python`
5. `python --version`
6. `pkg install -y git`
7. `git --version`

O estado só pode mudar para `PROVADO` quando o relatório `reports/device_pkg_smoke.json` declarar:

```text
DEVICE_REAL_PKG_VALIDATED
```

## Processo/zumbi e hot path RAFAELIA

Para provar vantagem computacional contra fricção de processo, use a floresta H5/H6 antes de afirmar ganho geral:

1. medir 100 execuções shell/processo;
2. medir 100/1000 execuções JNI/VCPU quando disponível;
3. capturar `ps -A`, logcat, latência p50/p95/p99 e memória;
4. salvar artefatos em `reports/`;
5. manter o estado como `PARCIAL` se a vantagem não estiver demonstrada.
