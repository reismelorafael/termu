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

## Modo device bloqueante

Para transformar smoke em gate obrigatório:

```bash
DEVICE_SMOKE_REQUIRED=true ./scripts/device_runtime_smoke.sh path/to/app.apk
```

O modo obrigatório falha quando `final_status != DEVICE_VALIDATED`.

## Payload core ARM real

Para gerar o core ARM real antes de promover `TOKEN_VAZIO` para `PROVADO`:

```bash
./scripts/build_real_arm_bootstrap_core.py --arch all
./scripts/validate_real_arm_bootstrap_core.py app/src/main/cpp/rewritten-bootstrap-aarch64.zip app/src/main/cpp/rewritten-bootstrap-arm.zip
DEVICE_SMOKE_REQUIRED=true ./scripts/device_runtime_smoke.sh path/to/app.apk
```

Promoção permitida somente depois de passar, em dispositivo real:

1. `pkg update`
2. `pkg install nano`
3. `nano --version`
4. `pkg install python`
5. `python --version`
6. `pkg install git`
7. `git --version`
