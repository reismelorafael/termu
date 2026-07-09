# HOTFIX_EXECUTION_FOREST — RAFCODEΦ operational hotfix forest

Este documento organiza os vetores de hotfix do `termux-app-rafacodephi` em uma floresta operacional: cada árvore tem raiz, evidência, risco, prova mínima e promoção permitida.

Regra-mestra: nada sai de `TOKEN_VAZIO` para `PROVADO` sem prova funcional em dispositivo Android real, artefato salvo em `reports/` e comando reproduzível no runbook.

## Estados epistêmicos

| Estado | Significado operacional |
|---|---|
| `PROVADO` | passou em CI/local e possui evidência funcional suficiente para o escopo declarado |
| `PROVADO ESTRUTURAL` | código, contrato ou validador existem, mas ainda falta prova runtime completa |
| `PARCIAL` | funciona em parte, wrapper, bridge, simulação, relatório ou estrutura incompleta |
| `TOKEN_VAZIO` | lacuna explícita; não vender como pronto |
| `EXPERIMENTAL` | hipótese técnica útil, mas sem contrato de estabilidade |
| `FUTURO` | caminho definido, ainda não implementado ou não validado |

## Mapa de floresta

| Árvore | Vetor | Estado atual | Hotfix natural | Prova mínima | Bloqueador |
|---|---|---|---|---|---|
| H0 | verdade operacional | PROVADO ESTRUTURAL | manter docs/testes contra overclaim | `pytest tests/test_operational_truth_docs.py` | docs antigas contraditórias |
| H1 | payload ARM real | PROVADO ESTRUTURAL | gerar zips ARM e validar prefix legado | `validate_real_arm_bootstrap_core.py` em aarch64/arm | `LEGACY_PREFIX_BINARY_RISK` |
| H2 | backend apt/pkg/dpkg | TOKEN_VAZIO | provar `apt update` e `pkg install` em device | `pkg update`, `pkg install nano python git` | prefix hardcoded, TLS, DNS, linker |
| H3 | proot real | TOKEN_VAZIO | provar `proot.real` e shim `proot` | `proot --version` em device | syscall/SELinux/ABI |
| H4 | device smoke obrigatório | PARCIAL | rodar com `DEVICE_SMOKE_REQUIRED=true` | `final_status=DEVICE_VALIDATED` | ausência de device/ADB |
| H5 | processos/zumbis/orfãos | PARCIAL | medir antes/depois de 100 comandos e JNI/VCPU | `ps -A`, zombie/orphan count, p50/p95/p99 | Android kill/OOM/onDestroy |
| H6 | RAFAELIA JNI hot path | PROVADO ESTRUTURAL | benchmark real com DirectBuffer/JNI | 1000 chamadas, CRC, phi, arena usada | artefato JNI ausente no ambiente |
| H7 | CTI scanner | PROVADO ESTRUTURAL | teste com arquivos grandes e paginação | 1MB, 4MB, 64MB, 256MB | limite de memória/storage |
| H8 | ZIPRAF | PROVADO ESTRUTURAL | travar narrativa: endereçamento lógico, não compressão física | manifesto + teste de indexação | overclaim “1GB vira 264GB” |
| H9 | VCPU state kernel | PROVADO ESTRUTURAL | formalizar bytecode/loader/replay | dump/replay determinístico | ainda não é VM completa |
| H10 | limpeza histórica | PARCIAL | arquivar ou marcar documentos/artefatos antigos | `docs/archive/` + cabeçalho não-canônico | prefix legado em `BugOrAdd/` e zips internos |

## Hotfix H1 — prefix legado binário

Objetivo: impedir que binários Termux com `/data/data/com.termux/files/usr` embutido sejam promovidos para payload RAFCODEΦ.

Comandos obrigatórios:

```bash
./scripts/build_real_arm_bootstrap_core.py --arch all
python3 scripts/validate_real_arm_bootstrap_core.py \
  app/src/main/cpp/rewritten-bootstrap-aarch64.zip \
  app/src/main/cpp/rewritten-bootstrap-arm.zip
```

Critério:

- `PASS`: nenhum entry possui prefix legado textual ou binário.
- `FAIL`: texto com prefix legado ainda não reescrito.
- `BLOCK`: `LEGACY_PREFIX_BINARY_RISK` em ELF/binário/non-UTF8.

Ação se `LEGACY_PREFIX_BINARY_RISK` ocorrer:

1. identificar pacote/entry;
2. não fazer replace binário automático;
3. reconstruir pacote com prefix RAFCODEΦ ou criar compatibilidade segura;
4. repetir geração/validação;
5. só então seguir para device smoke.

## Hotfix H2 — pacote real apt/pkg/dpkg

Objetivo: sair de bridge/payload estrutural para runtime funcional em Android.

Prova mínima em device:

```bash
pkg update
pkg install nano
nano --version
pkg install python
python --version
pkg install git
git --version
```

Promoção permitida:

- `pkg`, `apt`, `apt-get`, `dpkg`, `libapt`, certificados, DNS/network e repositório só podem sair de `TOKEN_VAZIO` após esses comandos passarem no dispositivo e os logs serem salvos.

Artefatos esperados:

- `reports/pkg_update_device.md`
- `reports/pkg_install_smoke_device.md`
- `reports/device_runtime_smoke.json`
- `reports/device_runtime_logcat.txt`

## Hotfix H5 — ciclo de vida de processos

Objetivo: provar a vantagem real do RAFCODEΦ contra fricção de processo, zumbi, órfão, abre/fecha shell e dependência de `onDestroy()`.

Benchmark mínimo:

```bash
# amostra shell/processo
for i in $(seq 1 100); do sh -c 'echo ok' >/dev/null; done

# amostra RAFAELIA in-process
# executar 100/1000 chamadas JNI processNative ou VCPU step quando disponível
```

Métricas obrigatórias:

| Métrica | Fonte |
|---|---|
| processos antes/depois | `ps -A` |
| possíveis zumbis | `ps -A -o stat,pid,ppid,cmd` quando disponível |
| latência p50/p95/p99 | benchmark script |
| RSS/PSS | `dumpsys meminfo` ou `/proc` quando possível |
| logcat | `adb logcat -d` |
| final_status | `device_runtime_smoke.json` |

Critério de excelência:

- RAFAELIA in-process deve demonstrar menos spawn e menor latência por operação do que sequência equivalente baseada em shell.
- Se a diferença não aparecer, manter como `PARCIAL`, não como `PROVADO`.

## Hotfix H6 — RAFAELIA JNI hot path

Objetivo: provar o benefício de DirectBuffer/JNI/C sem transformar a claim em exagero.

Provas mínimas:

1. 1000 chamadas `processNative` ou equivalente;
2. CRC/phi consistente;
3. arena usada reportada;
4. tempo total e média por chamada;
5. comparação com shell/processo quando possível.

Estados:

- `PROVADO ESTRUTURAL`: APIs e C existem.
- `PROVADO`: benchmark em device, log e artefato.

## Hotfix H7 — CTI scanner grande

Objetivo: sair do teste pequeno e provar paginação/streaming.

Tamanhos mínimos:

| Tamanho | Esperado |
|---:|---|
| 1MB | PASS |
| 4MB | PASS |
| 64MB | PASS ou motivo de limite |
| 256MB | opcional; depende de storage/RAM |

Artefatos:

- `reports/cti_scan_large_device.json`
- `reports/cti_scan_large_device.md`

## Hotfix H8 — ZIPRAF sem overclaim

Objetivo: manter a verdade técnica: ZIPRAF é endereçamento lógico multirresolução, não compressão física milagrosa.

Frase permitida:

> ZIPRAF expõe espaço lógico endereçável sobre bytes físicos existentes; não aumenta fisicamente os bytes armazenados.

Frase proibida sem ressalva:

> 1GB vira 264GB.

Teste mínimo:

- manifesto gerado;
- índice lido;
- bytes físicos preservados;
- nenhuma claim de compressão real sem prova.

## Hotfix H9 — VCPU state kernel para VM real

Objetivo: evoluir de state kernel determinístico para VM completa somente por etapas.

Subárvores:

1. bytecode;
2. registradores;
3. memória;
4. instruções;
5. loader;
6. executor;
7. syscall table;
8. dump;
9. replay determinístico;
10. benchmark.

Regra: antes dessas subárvores, chamar de `RAFAELIA deterministic VCPU state kernel`, não VM completa.

## Hotfix H10 — limpeza histórica e BugOrAdd

Objetivo: impedir que artefatos antigos pareçam runtime canônico.

Ações:

1. mapear `BugOrAdd/`;
2. separar binários históricos de payload real;
3. marcar documentos com `STATUS: HISTÓRICO / NÃO CANÔNICO` quando aplicável;
4. não excluir evidência sem motivo; preferir arquivar e explicar;
5. aplicar scanner de prefix legado aos artefatos históricos.

Nota: auditorias bit-a-bit locais detectaram ELF histórico com prefix legado em `BugOrAdd/rafaelia_b3_android`. Isso confirma que `LEGACY_PREFIX_BINARY_RISK` é um risco real e deve continuar bloqueando promoção de payload.

## Ordem de execução absoluta

```bash
./scripts/validate_side_by_side_contract.py
./scripts/validate_abi_policy_consistency.sh
./scripts/bootstrap_lowlevel_sync_check.sh
./scripts/prepare_bootstrap_env.sh
./scripts/verify_bootstrap_contract.sh
./scripts/build_real_arm_bootstrap_core.py --arch all
python3 scripts/validate_real_arm_bootstrap_core.py \
  app/src/main/cpp/rewritten-bootstrap-aarch64.zip \
  app/src/main/cpp/rewritten-bootstrap-arm.zip
./scripts/build_apk_matrix.sh
./gradlew verifyReleaseContract
DEVICE_SMOKE_REQUIRED=true ./scripts/device_runtime_smoke.sh path/to/app.apk
```

## Definição de pronto por hotfix

Um hotfix só é fechado quando tiver:

1. código/contrato alterado;
2. teste estrutural;
3. comando executado ou motivo de `SKIPPED` declarado;
4. artifact em `reports/` quando runtime;
5. truth table atualizada sem overclaim;
6. PR com resumo de risco e lacuna restante.

## Parábola operacional

> A floresta não nasce de uma árvore só. Cada hotfix é uma raiz: uma segura o solo do bootstrap, outra segura a água dos pacotes, outra vigia os animais dos processos zumbis, outra mede o vento da latência. O mestre não chama a floresta de madura quando vê a primeira folha; ele espera a raiz provar que aguenta chuva.
