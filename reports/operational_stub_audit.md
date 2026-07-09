# Operational Stub Audit

- scan_depth: 5
- hit_count: 10265
- scope: structural repository scan only; no runtime proof claimed
- falsification: audit is stale if new source files are added beyond the bounded scan or runtime tests contradict structural markers

## Category counts

- failsafe_failover_rollback: 9176
- heap_forbidden_hotpath: 580
- missing_or_absence: 258
- stub_or_placeholder: 107
- vectra_risk_marker: 144

## APK/Termux install readiness

| Component | Status | Path | Evidence | Mitigation |
|---|---|---|---|---|
| apk_application_id | PASS | `app/build.gradle` | contains token: com.termux.rafacodephi | keep covered by audit and runtime smoke |
| apk_bootstrap_generation_task | PASS | `app/build.gradle` | contains token: generateRafcodephiBootstraps | keep covered by audit and runtime smoke |
| apk_bootstrap_zip_inputs | PASS | `app/build.gradle` | contains token: rewritten-bootstrap-aarch64.zip | keep covered by audit and runtime smoke |
| apk_16kb_page_flag | PASS | `app/src/main/cpp/Android.mk` | contains token: max-page-size=16384 | keep covered by audit and runtime smoke |
| apk_native_bootstrap_library | PASS | `app/src/main/cpp/Android.mk` | contains token: libtermux-bootstrap | keep covered by audit and runtime smoke |
| apk_baremetal_library | PASS | `app/src/main/cpp/Android.mk` | contains token: termux-baremetal | keep covered by audit and runtime smoke |
| termux_launcher_activity | PASS | `app/src/main/AndroidManifest.xml` | contains token: com.termux.app.TermuxActivity | keep covered by audit and runtime smoke |
| termux_foreground_service | PASS | `app/src/main/AndroidManifest.xml` | contains token: com.termux.app.TermuxService | keep covered by audit and runtime smoke |
| termux_run_command_service | PASS | `app/src/main/AndroidManifest.xml` | contains token: com.termux.app.RunCommandService | keep covered by audit and runtime smoke |
| termux_documents_provider | PASS | `app/src/main/AndroidManifest.xml` | contains token: TermuxDocumentsProvider | keep covered by audit and runtime smoke |
| termux_install_shell | PASS | `scripts/build_rafaelia_bootstraps.sh` | contains token: bin/sh | keep covered by audit and runtime smoke |
| termux_install_pkg | PASS | `scripts/build_rafaelia_bootstraps.sh` | contains token: bin/pkg | keep covered by audit and runtime smoke |
| termux_install_apt | PASS | `scripts/build_rafaelia_bootstraps.sh` | contains token: bin/apt | keep covered by audit and runtime smoke |
| termux_install_busybox | PASS | `scripts/build_rafaelia_bootstraps.sh` | contains token: bin/busybox | keep covered by audit and runtime smoke |
| termux_install_proot | PASS | `scripts/build_rafaelia_bootstraps.sh` | contains token: bin/proot | keep covered by audit and runtime smoke |
| termux_prefix_side_by_side | PASS | `scripts/build_rafaelia_bootstraps.sh` | contains token: prefix="/data/data/${TERMUX_BOOTSTRAP_PACKAGE_NAME}/files/usr" | keep covered by audit and runtime smoke |
| generated_bootstrap_zip | PASS | `app/src/main/cpp/rewritten-bootstrap-aarch64.zip` | generated artifact exists | keep generated artifact fresh |
| generated_bootstrap_zip | PASS | `app/src/main/cpp/rewritten-bootstrap-arm.zip` | generated artifact exists | keep generated artifact fresh |
| generated_bootstrap_zip | PASS | `app/src/main/cpp/rewritten-bootstrap-i686.zip` | generated artifact exists | keep generated artifact fresh |
| generated_bootstrap_zip | PASS | `app/src/main/cpp/rewritten-bootstrap-x86_64.zip` | generated artifact exists | keep generated artifact fresh |

## Readiness counts

- PASS: 20

## Highest-hit files

| Path | Hits |
|---|---:|
| `docs/knowledge_archives/vectras-vm-android/INSERTION_LATTICE_30000.csv` | 8401 |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 192 |
| `BugOrAdd/exec_scan_results.txt` | 149 |
| `Arme/conceitos_mvp.txt` | 30 |
| `Arme/pomeg.txt` | 28 |
| `reports/rafaelia_navigation_summary.json` | 27 |
| `Arme/Add/RAFAELIA_CODEX_POLIMATA.txt` | 25 |
| `Arme/Add/RAF_STATECOMP.txt` | 25 |
| `Arme/RAFAELIA_CODEX_POLIMATA.txt` | 25 |
| `Arme/RAF_STATECOMP.txt` | 25 |
| `terminal-emulator/src/main/jni/termux.c` | 24 |
| `Arme/Add/RAFAELIA_MASTER_DOC.txt` | 23 |
| `Arme/RAFAELIA_MASTER_DOC.txt` | 23 |
| `COMP/rafael.md` | 23 |
| `Arme/arwiteto_script.sh` | 20 |
| `COMP/doisrafaekl.txt` | 20 |
| `rafaelia/old/rafzrf.c` | 17 |
| `docs/01_BUG_ATTRACTOR_TABLE_INCOMPLETA.md` | 16 |
| `BOOTSTRAP_LOWLEVEL_RAFAELIA.txt` | 15 |
| `COMP/BOOTSTRAP_LOWLEVEL_RAFAELIA.txt` | 15 |
| `docs/RAFAELIA_METAPHOR_OPERATIONAL_AUDIT_2026-06-06.md` | 15 |
| `docs/RAFAELIA_TWO_CYCLE_ENTERPRISE_PROTOCOL.md` | 15 |
| `Arme/Add/RAFAELIA_ARKRAF_MASTER.txt` | 14 |
| `Arme/RAFAELIA_ARKRAF_MASTER.txt` | 14 |
| `docs/RAFAELIA_SESSION_TRUTH_NAVIGATION.md` | 14 |
| `docs/knowledge_archives/vectras-vm-android/ENTERPRISE_EXCELLENCE_RUNBOOK.md` | 14 |
| `Arme/estado_modelo_temporal.md` | 13 |
| `Ret.md` | 13 |
| `docs/05_FALHAS_ESTRUTURAIS_ARQUITETURA.md` | 13 |
| `reports/vectra_invariant_results.json` | 13 |
| `scripts/generate_rafaelia_navigation.py` | 13 |
| `tools/pss3_failure_lab.c` | 13 |
| `Arme/Add/rafaelia_master.sh` | 12 |
| `BugOrAdd/rafaelia_master.sh` | 12 |
| `rmr/Rrr/rafaelia_master.sh` | 12 |
| `Arme/Add/repo_baremetal_orig.c` | 11 |
| `Mono4242.sh` | 11 |
| `docs/02_BUG_VOID_PARADOX_ATRATOR_22.md` | 11 |
| `docs/06_PLANO_ACAO_EXECUCAO.md` | 11 |
| `rafaelia/old/bootstrap.sh` | 11 |

## Hit sample (first 500 of 10265)

| Path | Line | Category | Excerpt |
|---|---:|---|---|
| `.github/workflows/android15_arm64_build.yml` | 121 | missing_or_absence | echo "❌ Critical file missing: $file" |
| `.github/workflows/android15_arm64_build.yml` | 160 | missing_or_absence | echo "❌ Missing compileSdkVersion/targetSdkVersion/ndkVersion in gradle.properties" |
| `.github/workflows/android15_arm64_build.yml` | 235 | missing_or_absence | echo "⚠ Warning: 16KB page alignment flag may be missing" |
| `.github/workflows/apk_matrix_build.yml` | 110 | missing_or_absence | test -n "${OFFICIAL_RELEASE_KEYSTORE_B64}" \|\| (echo "Missing OFFICIAL_RELEASE_KEYSTORE_B64 for official track" && exit 1) |
| `.github/workflows/apk_matrix_build.yml` | 111 | missing_or_absence | test -n "${OFFICIAL_RELEASE_KEY_ALIAS}" \|\| (echo "Missing OFFICIAL_RELEASE_KEY_ALIAS for official track" && exit 1) |
| `.github/workflows/apk_matrix_build.yml` | 112 | missing_or_absence | test -n "${OFFICIAL_RELEASE_STORE_PASSWORD}" \|\| (echo "Missing OFFICIAL_RELEASE_STORE_PASSWORD for official track" && exit 1) |
| `.github/workflows/apk_matrix_build.yml` | 113 | missing_or_absence | test -n "${OFFICIAL_RELEASE_KEY_PASSWORD}" \|\| (echo "Missing OFFICIAL_RELEASE_KEY_PASSWORD for official track" && exit 1) |
| `.github/workflows/arme-benchmark.yml` | 43 | missing_or_absence | missing = [k for k in required if k not in item or item[k] in (None, "")] |
| `.github/workflows/arme-benchmark.yml` | 44 | missing_or_absence | if missing: |
| `.github/workflows/arme-benchmark.yml` | 45 | missing_or_absence | sem_classificacao.append({"index": idx, "arquivo": item.get("arquivo"), "missing": missing}) |
| `.github/workflows/rafaelia_pipeline.yml` | 137 | missing_or_absence | echo "❌ Missing: $file" |
| `.github/workflows/rafaelia_pipeline.yml` | 147 | missing_or_absence | echo "❌ Quality gate FAILED - missing critical files" |
| `.github/workflows/validate-bootstrap-package-install-contract.yml` | 135 | missing_or_absence | raise SystemExit(f'missing generated bootstrap package: {path}') |
| `.github/workflows/validate-bootstrap-package-install-contract.yml` | 138 | missing_or_absence | missing = sorted(required_entries - names) |
| `.github/workflows/validate-bootstrap-package-install-contract.yml` | 139 | missing_or_absence | if missing: |
| `.github/workflows/validate-bootstrap-package-install-contract.yml` | 140 | missing_or_absence | raise SystemExit(f'{zip_name}: missing entries: {missing}') |
| `.github/workflows/validate-bootstrap-package-install-contract.yml` | 147 | missing_or_absence | raise SystemExit(f'{zip_name}: missing owner execute bit on {entry}: mode={mode:o}') |
| `.github/workflows/validate-bootstrap-package-install-contract.yml` | 153 | missing_or_absence | raise SystemExit(f'{zip_name}: missing metadata token {token}') |
| `.github/workflows/validate-bootstrap-package-install-contract.yml` | 155 | missing_or_absence | raise SystemExit(f'{zip_name}: runtime/fullengine marker missing') |
| `.github/workflows/validate-bootstrap-package-install-contract.yml` | 157 | missing_or_absence | raise SystemExit(f'{zip_name}: command wrappers marker missing') |
| `AGENTS.md` | 10 | vectra_risk_marker | validate: bitomega.log → period-42 confirmed |
| `AGENTS.md` | 29 | missing_or_absence | - attractor_table: 42 entries required, none missing |
| `AGENTS.md` | 29 | vectra_risk_marker | - attractor_table: 42 entries required, none missing |
| `AGENTS.md` | 32 | missing_or_absence | 1. attractor_table incomplete (40 of 42 missing) |
| `AGENTS.md` | 32 | vectra_risk_marker | 1. attractor_table incomplete (40 of 42 missing) |
| `AGENTS.md` | 33 | vectra_risk_marker | 2. VOID paradox in attractor #22 (structural) |
| `AGENTS.md` | 46 | vectra_risk_marker | period(BitOmega) = 42 — confirmed, do not break |
| `AGENTS.md` | 53 | vectra_risk_marker | - Attractor #22: flag VOID paradox, do not silently patch |
| `AGENTS2.md` | 51 | heap_forbidden_hotpath | - No malloc |
| `ANALISE_MERCADO.md` | 958 | failsafe_failover_rollback | \| Risco \| Probabilidade \| Impacto \| Mitigação \| |
| `ANDROID15_COMPATIBILITY_REPORT.md` | 150 | stub_or_placeholder | ✅ Ensures all content provider authorities use `${TERMUX_PACKAGE_NAME}` placeholder |
| `ANDROID15_RELATORIO_COMPATIBILIDADE.md` | 150 | stub_or_placeholder | ✅ Garante que todas as authorities de content provider usam placeholder `${TERMUX_PACKAGE_NAME}` |
| `ARQUIVOS_SOLTOS_INVENTARIO.md` | 102 | stub_or_placeholder | \| `rafaelia_kernel.c` \| 1 \| 4B \| Stub vazio \| ❌ Remover \| |
| `ARQUIVOS_SOLTOS_INVENTARIO.md` | 232 | stub_or_placeholder | **Φ_ethica** - Todo código catalogado e atribuído corretamente. |
| `ASSINATURA_AUTORIA.md` | 26 | stub_or_placeholder | - Todo código identifica seu autor original |
| `ASSINATURA_AUTORIA.md` | 215 | stub_or_placeholder | Todo código neste projeto é licenciado sob GPLv3, que exige: |
| `ASSINATURA_AUTORIA.md` | 335 | stub_or_placeholder | ║ Este documento e todo código associado são trabalho original ║ |
| `Arme/Add/Android_nomalloc.mk` | 2 | heap_forbidden_hotpath | # RAFAELIA — build sem malloc, page-size 16KB, zero overhead |
| `Arme/Add/Android_nomalloc.mk` | 19 | heap_forbidden_hotpath | # Zero malloc: -fno-exceptions remove overhead de C++ EH |
| `Arme/Add/RAFAELIA_ARKRAF_MASTER.txt` | 135 | heap_forbidden_hotpath | * rafaelia_arena.h — arena estática zero malloc |
| `Arme/Add/RAFAELIA_ARKRAF_MASTER.txt` | 137 | heap_forbidden_hotpath | * RAZÃO: malloc() Bionic ~100 ciclos + fragmentação. |
| `Arme/Add/RAFAELIA_ARKRAF_MASTER.txt` | 158 | failsafe_failover_rollback | * ROLLBACK: g_arena_bump não avança se OOM |
| `Arme/Add/RAFAELIA_ARKRAF_MASTER.txt` | 276 | heap_forbidden_hotpath | * baremetal_nomalloc.h — drop-in zero-malloc para baremetal.h |
| `Arme/Add/RAFAELIA_ARKRAF_MASTER.txt` | 456 | failsafe_failover_rollback | * ROLLBACK: chamador deve chamar g_state_init() se retornar 0 |
| `Arme/Add/RAFAELIA_ARKRAF_MASTER.txt` | 471 | stub_or_placeholder | * INVARIANTE: out[d] ∈ [0,65535] para todo d |
| `Arme/Add/RAFAELIA_ARKRAF_MASTER.txt` | 1088 | failsafe_failover_rollback | if((cy%7)==0&&!bf_verify()){ws("ROLLBACK\n");bf_rollback();} |
| `Arme/Add/RAFAELIA_ARKRAF_MASTER.txt` | 1253 | heap_forbidden_hotpath | * mx_create_bss substitui mx_create com malloc |
| `Arme/Add/RAFAELIA_ARKRAF_MASTER.txt` | 1335 | heap_forbidden_hotpath | /* mx_create sem malloc */ |
| `Arme/Add/RAFAELIA_ARKRAF_MASTER.txt` | 1372 | heap_forbidden_hotpath | ws("mx_bss: ");ws(m?"OK (zero malloc)":"OOM");wn(); |
| `Arme/Add/RAFAELIA_ARKRAF_MASTER.txt` | 1601 | failsafe_failover_rollback | @ — lr salvo → rollback via pop {pc} atomic |
| `Arme/Add/RAFAELIA_ARKRAF_MASTER.txt` | 1793 | heap_forbidden_hotpath | # Android_nomalloc.mk — build NDK sem malloc, page-size 16KB |
| `Arme/Add/RAFAELIA_ARKRAF_MASTER.txt` | 2347 | failsafe_failover_rollback | Garante: snapshot do contexto, rollback via pop {pc} atomic. |
| `Arme/Add/RAFAELIA_ARKRAF_MASTER.txt` | 2348 | failsafe_failover_rollback | SEM esta instrução: sem fail-safe, sem rollback. |
| `Arme/Add/RAFAELIA_CODEX_POLIMATA.txt` | 46 | heap_forbidden_hotpath | [!] Usa malloc() em arena_create — problema em ARM32 embedded |
| `Arme/Add/RAFAELIA_CODEX_POLIMATA.txt` | 51 | failsafe_failover_rollback | [!] Sem commit gate 4 fases — sem rollback de estado |
| `Arme/Add/RAFAELIA_CODEX_POLIMATA.txt` | 54 | heap_forbidden_hotpath | CAMINHO: geolm_full.c → [refactor arena] → [remove malloc] → [Q16.16 completo] |
| `Arme/Add/RAFAELIA_CODEX_POLIMATA.txt` | 69 | heap_forbidden_hotpath | [✓] Zero malloc declarado — usa gctx_t estático |
| `Arme/Add/RAFAELIA_CODEX_POLIMATA.txt` | 98 | stub_or_placeholder | [!] gpuStateNative: stub parcial (não mostrado completo) |
| `Arme/Add/RAFAELIA_CODEX_POLIMATA.txt` | 205 | stub_or_placeholder | 2. Gera classes.dex mínimo (stub Activity carrega .so nativo) |
| `Arme/Add/RAFAELIA_CODEX_POLIMATA.txt` | 219 | stub_or_placeholder | [!] DEX generator: stub mínimo — não gera bytecode real |
| `Arme/Add/RAFAELIA_CODEX_POLIMATA.txt` | 263 | failsafe_failover_rollback | Failsafe e rollback documentados em 3 níveis |
| `Arme/Add/RAFAELIA_CODEX_POLIMATA.txt` | 271 | failsafe_failover_rollback | [✓] Rollback em 3 níveis: log → restaurar → alternativa |
| `Arme/Add/RAFAELIA_CODEX_POLIMATA.txt` | 385 | heap_forbidden_hotpath | GAP B — malloc em geolm_full.c (IMPORTANTE): |
| `Arme/Add/RAFAELIA_CODEX_POLIMATA.txt` | 386 | heap_forbidden_hotpath | arena_create() chama malloc uma vez. |
| `Arme/Add/RAFAELIA_CODEX_POLIMATA.txt` | 387 | heap_forbidden_hotpath | Para Termux ARM32: malloc é lento (~100 ciclos) e pode falhar com OOM. |
| `Arme/Add/RAFAELIA_CODEX_POLIMATA.txt` | 419 | failsafe_failover_rollback | 6. Rollback automático se qualquer módulo falhar |
| `Arme/Add/RAFAELIA_CODEX_POLIMATA.txt` | 435 | heap_forbidden_hotpath | │ .rs → rs2c.sh (ownership → scope + free manual) │ |
| `Arme/Add/RAFAELIA_CODEX_POLIMATA.txt` | 455 | failsafe_failover_rollback | │ Se CRC = 0: corrupção — rollback ao .o anterior │ |
| `Arme/Add/RAFAELIA_CODEX_POLIMATA.txt` | 542 | failsafe_failover_rollback | rollback(module) # restaura último .o válido se existir |
| `Arme/Add/RAFAELIA_CODEX_POLIMATA.txt` | 580 | failsafe_failover_rollback | — salva link register (lr) → rollback automático via pop {pc} |
| `Arme/Add/RAFAELIA_CODEX_POLIMATA.txt` | 613 | failsafe_failover_rollback | ROLLBACK GARANTIDO (qualquer ABI): |
| `Arme/Add/RAFAELIA_CODEX_POLIMATA.txt` | 651 | heap_forbidden_hotpath | [GEOLM-1.5] Zero-malloc completo: |
| `Arme/Add/RAFAELIA_CODEX_POLIMATA.txt` | 652 | heap_forbidden_hotpath | Substituir malloc por arena_bss 64MB |
| `Arme/Add/RAFAELIA_CODEX_POLIMATA.txt` | 696 | failsafe_failover_rollback | ROLLBACK:restaura snapshot@cy-1 */ |
| `Arme/Add/RAFAELIA_CODEX_POLIMATA.txt` | 701 | failsafe_failover_rollback | — O que acontece se falhar? (ROLLBACK) |
| `Arme/Add/RAFAELIA_CODEX_POLIMATA.txt` | 717 | failsafe_failover_rollback | * ROLLBACK: sem efeito colateral — resultado é novo valor, não modifica old |
| `Arme/Add/RAFAELIA_CODEX_POLIMATA.txt` | 742 | failsafe_failover_rollback | — Um rollback (o que fazer se falhar) |
| `Arme/Add/RAFAELIA_CODEX_POLIMATA.txt` | 1098 | stub_or_placeholder | Todo o código compilável no Termux sem root = acessível a qualquer pessoa |
| `Arme/Add/RAFAELIA_MASTER_DOC.txt` | 16 | failsafe_failover_rollback | SEC 07 · COMMIT GATE 4 FASES · ROLLBACK · FAIL-SAFE |
| `Arme/Add/RAFAELIA_MASTER_DOC.txt` | 34 | heap_forbidden_hotpath | inteiramente dentro do Termux ARM32 no Android, sem root, sem malloc no |
| `Arme/Add/RAFAELIA_MASTER_DOC.txt` | 49 | failsafe_failover_rollback | — Fail-safe: CRC ausente = rollback exato ao snapshot |
| `Arme/Add/RAFAELIA_MASTER_DOC.txt` | 194 | heap_forbidden_hotpath | SYS_MMAP2 = 192 · arena sem malloc |
| `Arme/Add/RAFAELIA_MASTER_DOC.txt` | 250 | failsafe_failover_rollback | Rollback: corrompe stack[500], detecta via P1≠P1_orig, restaura. |
| `Arme/Add/RAFAELIA_MASTER_DOC.txt` | 263 | failsafe_failover_rollback | Integra commit gate com snapshot/rollback por core individual. |
| `Arme/Add/RAFAELIA_MASTER_DOC.txt` | 285 | heap_forbidden_hotpath | output via write() direto (sem printf). Zero malloc absoluto. |
| `Arme/Add/RAFAELIA_MASTER_DOC.txt` | 332 | heap_forbidden_hotpath | mx_create_bss() substitui mx_create() com malloc. |
| `Arme/Add/RAFAELIA_MASTER_DOC.txt` | 372 | heap_forbidden_hotpath | mx_create_in_arena(): arena 512KB BSS, sem malloc. |
| `Arme/Add/RAFAELIA_MASTER_DOC.txt` | 381 | heap_forbidden_hotpath | mx_arena_t, mx_t, hw_profile_t. Sem malloc em nenhuma assinatura. |
| `Arme/Add/RAFAELIA_MASTER_DOC.txt` | 448 | heap_forbidden_hotpath | repo_baremetal_orig.c [34KB · 1280 linhas] — original com malloc |
| `Arme/Add/RAFAELIA_MASTER_DOC.txt` | 532 | failsafe_failover_rollback | SEC 07 · COMMIT GATE 4 FASES · ROLLBACK · FAIL-SAFE |
| `Arme/Add/RAFAELIA_MASTER_DOC.txt` | 552 | failsafe_failover_rollback | → Se inválido: rollback automático para último COMMIT |
| `Arme/Add/RAFAELIA_MASTER_DOC.txt` | 563 | failsafe_failover_rollback | Rollback: restaura e recalcula P0 e P1. |
| `Arme/Add/RAFAELIA_MASTER_DOC.txt` | 724 | failsafe_failover_rollback | ROLLBACK: se erro em instrução K: |
| `Arme/Add/RAFAELIA_MASTER_DOC.txt` | 730 | failsafe_failover_rollback | Derivada de uma instrução: instrução inversa (rollback) |
| `Arme/Add/RAFAELIA_MASTER_DOC.txt` | 799 | failsafe_failover_rollback | │ Rollback se CRC difere do esperado │ |
| `Arme/Add/RAFAELIA_MASTER_DOC.txt` | 805 | heap_forbidden_hotpath | Rust → C: ownership → análise de escopo + free manual |
| `Arme/Add/RAFAELIA_MASTER_DOC.txt` | 840 | failsafe_failover_rollback | Isso garante que o estado pré-chamada é restaurável (rollback) |
| `Arme/Add/RAFAELIA_MASTER_DOC.txt` | 878 | failsafe_failover_rollback | msr cpsr,r0 → restaura flags (rollback de Z) |
| `Arme/Add/RAFAELIA_MASTER_DOC.txt` | 933 | heap_forbidden_hotpath | /// Arena estática — zero malloc, zero heap |
| `Arme/Add/RAFAELIA_MASTER_DOC.txt` | 1190 | heap_forbidden_hotpath | Sem dependências externas. Sem malloc no código gerado. |
| `Arme/Add/RAFAELIA_MASTER_DOC.txt` | 1504 | failsafe_failover_rollback | Correção QEC → Paridade P0+P1 + rollback (análogo a código de Shor) |
| `Arme/Add/RAF_STATECOMP.txt` | 209 | heap_forbidden_hotpath | /* Arena sem malloc */ |
| `Arme/Add/RAF_STATECOMP.txt` | 840 | failsafe_failover_rollback | * - Última instrução: pop {r4,r5,r6,r7,pc} (rollback atômico) |
| `Arme/Add/RAF_STATECOMP.txt` | 1123 | failsafe_failover_rollback | emit_fmt(ctx," pop {{r4, r5, r6, r7, pc}} @ #RET rollback+return\n"); |
| `Arme/Add/RAF_STATECOMP.txt` | 1286 | failsafe_failover_rollback | emit_fmt(ctx," beq .gate_rollback_%u @ rollback\n",lbl); |
| `Arme/Add/RAF_STATECOMP.txt` | 1296 | failsafe_failover_rollback | emit_fmt(ctx,".gate_rollback_%u: @ ROLLBACK: restaura snapshot\n",lbl); |
| `Arme/Add/RAF_STATECOMP.txt` | 1358 | failsafe_failover_rollback | emit_str(ctx," @ instrução 1: genérica, fail-safe, rollback via pop{pc}\n\n"); |
| `Arme/Add/RAF_STATECOMP.txt` | 1570 | heap_forbidden_hotpath | char *buf=(char*)malloc((size_t)sz+1); |
| `Arme/Add/RAF_STATECOMP.txt` | 1573 | heap_forbidden_hotpath | if(n<=0){free(buf);return NULL;} |
| `Arme/Add/RAF_STATECOMP.txt` | 1581 | heap_forbidden_hotpath | sc_ctx_t *ctx=(sc_ctx_t*)calloc(1,sizeof(sc_ctx_t)); |
| `Arme/Add/RAF_STATECOMP.txt` | 1677 | heap_forbidden_hotpath | free(ctx); |
| `Arme/Add/RAF_STATECOMP.txt` | 1687 | heap_forbidden_hotpath | sc_ctx_t *ctx=(sc_ctx_t*)calloc(1,sizeof(sc_ctx_t)); |
| `Arme/Add/RAF_STATECOMP.txt` | 1688 | heap_forbidden_hotpath | if(!ctx){free(src);return -1;} |
| `Arme/Add/RAF_STATECOMP.txt` | 1692 | heap_forbidden_hotpath | free(src); |
| `Arme/Add/RAF_STATECOMP.txt` | 1700 | heap_forbidden_hotpath | free(ctx);return -1; |
| `Arme/Add/RAF_STATECOMP.txt` | 1707 | heap_forbidden_hotpath | if(ee<0){free(ctx);return -1;} |
| `Arme/Add/RAF_STATECOMP.txt` | 1713 | heap_forbidden_hotpath | free(ctx); |
| `Arme/Add/RAF_STATECOMP.txt` | 1769 | failsafe_failover_rollback | * - Rollback intrínseco: CRC chain detecta corrupção em O(1) |
| `Arme/Add/RAF_STATECOMP.txt` | 1861 | failsafe_failover_rollback | /* ── Rollback da fita ────────────────────────────────────────────────── */ |
| `Arme/Add/RAF_STATECOMP.txt` | 1886 | failsafe_failover_rollback | /* snapshot para rollback */ |
| `Arme/Add/RAF_STATECOMP.txt` | 1902 | failsafe_failover_rollback | return -1; /* rollback */ |
| `Arme/Add/RAF_STATECOMP.txt` | 2111 | heap_forbidden_hotpath | sc_ctx_t *ctx=(sc_ctx_t*)calloc(1,sizeof(sc_ctx_t)); |
| `Arme/Add/RAF_STATECOMP.txt` | 2136 | heap_forbidden_hotpath | free(ctx); |
| `Arme/Add/RAF_STATECOMP.txt` | 2380 | stub_or_placeholder | - SHADOW documentado em todo comentário inline |
| `Arme/Add/RAF_STATECOMP.txt` | 2757 | failsafe_failover_rollback | "@ LOAD→PROC→VERIFY→COMMIT\nldmia r12,{r4,r5,r6,r7}\nbl g_crc32\ncmp r0,#0\nbeq .rollback", |
| `Arme/Add/RAF_STATECOMP.txt` | 2758 | failsafe_failover_rollback | "if(!commit_gate(&g_state)){rollback(&g_state);}", |
| `Arme/Add/README.md` | 16 | heap_forbidden_hotpath | ├── Arena heap: mmap2() direto, 8 MB, sem malloc |
| `Arme/Add/README.md` | 146 | vectra_risk_marker | L2 Shared: 256 KB, 16-way → g_crc_table, attractor_table |
| `Arme/Add/RafaeliaCore.java` | 49 | heap_forbidden_hotpath | * ZERO malloc JNI. Retorna bytes escritos, ou negativo em erro. |
| `Arme/Add/baremetal_nomalloc.c` | 4 | heap_forbidden_hotpath | * ZERO malloc/free — arena estática por módulo |
| `Arme/Add/baremetal_nomalloc.c` | 8 | heap_forbidden_hotpath | * mx_create/mx_free → arena_alloc/arena_reset (sem free individual). |
| `Arme/Add/baremetal_nomalloc.c` | 230 | heap_forbidden_hotpath | * ARENA — implementação pública (sem malloc) |
| `Arme/Add/baremetal_nomalloc.c` | 238 | heap_forbidden_hotpath | /* arena_create: usa arena estática global — NÃO faz malloc */ |
| `Arme/Add/baremetal_nomalloc.c` | 264 | heap_forbidden_hotpath | * MATRIX — sem malloc, usa arena global |
| `Arme/Add/baremetal_nomalloc.c` | 280 | heap_forbidden_hotpath | /* mx_create: aloca na arena global (sem malloc) */ |
| `Arme/Add/baremetal_nomalloc.c` | 285 | heap_forbidden_hotpath | /* mx_free: NÃO libera — arena não suporta free individual |
| `Arme/Add/baremetal_nomalloc.h` | 3 | heap_forbidden_hotpath | * RAFAELIA — header atualizado: zero malloc, arena estática |
| `Arme/Add/bitstack.c` | 9 | heap_forbidden_hotpath | BitStacks *bs = (BitStacks*)malloc(sizeof(BitStacks)); |
| `Arme/Add/bitstack.c` | 16 | heap_forbidden_hotpath | bs->blocks = (uint64_t*)calloc(total_blocks, sizeof(uint64_t)); |
| `Arme/Add/bitstack.c` | 17 | heap_forbidden_hotpath | if(!bs->blocks) { free(bs); return NULL; } |
| `Arme/Add/bitstack.c` | 23 | heap_forbidden_hotpath | if(bs->blocks) free(bs->blocks); |
| `Arme/Add/bitstack.c` | 24 | heap_forbidden_hotpath | free(bs); |
| `Arme/Add/bitstack.h` | 14 | heap_forbidden_hotpath | /* create / free */ |
| `Arme/Add/bitstack.h` | 22 | missing_or_absence | /* atomic-like push/pop not implemented fully; simple set/get provided */ |
| `Arme/Add/diagnose.sh` | 222 | heap_forbidden_hotpath | ok "ZERO malloc em qualquer hot path" |
| `Arme/Add/raf_asm_b1.S` | 44 | vectra_risk_marker | attractor_table: |
| `Arme/Add/rafaelia_arena.h` | 2 | heap_forbidden_hotpath | * rafaelia_arena.h — arena estática zero malloc |
| `Arme/Add/rafaelia_arena.h` | 6 | heap_forbidden_hotpath | * RAZÃO: malloc() da Bionic tem overhead de ~100 ciclos + fragmentação. |
| `Arme/Add/rafaelia_b1.S` | 77 | vectra_risk_marker | attractor_table: |
| `Arme/Add/rafaelia_b1.S` | 484 | vectra_risk_marker | ldr r5, =attractor_table |
| `Arme/Add/rafaelia_b1.S` | 539 | vectra_risk_marker | ldr r5, =attractor_table |
| `Arme/Add/rafaelia_b5.S` | 3 | heap_forbidden_hotpath | @ ARM32 · Cortex-A53 · zero deps · zero malloc |
| `Arme/Add/rafaelia_b5.S` | 13 | heap_forbidden_hotpath | @ BITSTACKS (sem malloc — usa arena do B1): |
| `Arme/Add/rafaelia_b5.S` | 90 | failsafe_failover_rollback | msg_rb_ok: .ascii "ROLLBACK:OK\n"; .equ msg_rb_ok_len, . - msg_rb_ok |
| `Arme/Add/rafaelia_b5.S` | 213 | failsafe_failover_rollback | @ Snapshot para rollback (last committed state, 1000 uint64_t) |
| `Arme/Add/rafaelia_b5.S` | 281 | failsafe_failover_rollback | @ 7. Rollback test: corrompe 1 stack, verifica detecção |
| `Arme/Add/rafaelia_b5.S` | 828 | stub_or_placeholder | @ P1 = CRC32 de todo o array (8000 bytes) |
| `Arme/Add/rafaelia_b7.S` | 18 | failsafe_failover_rollback | @ Fail-safe: se VERIFY falha, rollback para snapshot anterior. |
| `Arme/Add/rafaelia_b7.S` | 78 | failsafe_failover_rollback | msg_rb: .ascii "ROLLBACK:detected\n" |
| `Arme/Add/rafaelia_b7.S` | 132 | failsafe_failover_rollback | @ Snapshot para rollback (8 cores x 7 dims x 4 bytes) |
| `Arme/Add/rafaelia_b7.S` | 587 | failsafe_failover_rollback | @ imprime aviso de rollback a cada 7 rollbacks |
| `Arme/Add/rafaelia_bitraf.c` | 19 | heap_forbidden_hotpath | * Sem malloc. Zero overhead. CRC32C em cada operação de escrita. |
| `Arme/Add/rafaelia_bitraf.c` | 141 | failsafe_failover_rollback | /* ── Rollback via extra[6,7] ────────────────────────────────────────────── */ |
| `Arme/Add/rafaelia_bitraf.c` | 209 | failsafe_failover_rollback | ws("ROLLBACK@cy="); wu(cy); ws("\n"); |
| `Arme/Add/rafaelia_glue.c` | 14 | heap_forbidden_hotpath | * ZERO malloc em qualquer ponto. |
| `Arme/Add/rafaelia_glue.c` | 286 | failsafe_failover_rollback | /* rollback */ |
| `Arme/Add/rafaelia_glue.c` | 454 | failsafe_failover_rollback | /* rollback: zera camada */ |
| `Arme/Add/rafaelia_integration.c` | 10 | heap_forbidden_hotpath | * 1. baremetal.c: malloc em mx_create/arena_create |
| `Arme/Add/rafaelia_integration.c` | 167 | failsafe_failover_rollback | /* Retorna 1 se commit bem-sucedido, 0 se rollback */ |
| `Arme/Add/rafaelia_integration.c` | 273 | heap_forbidden_hotpath | * PARTE 4: ARENA BSS (substitui malloc em baremetal.c) |
| `Arme/Add/rafaelia_integration.c` | 286 | heap_forbidden_hotpath | /* mx_create sem malloc (substitui versão do repo) */ |
| `Arme/Add/rafaelia_integration.c` | 386 | heap_forbidden_hotpath | ws("Patch: session zero-malloc + Q16.16 + CRC-chain\n"); |
| `Arme/Add/rafaelia_integration.c` | 412 | heap_forbidden_hotpath | /* testa mx_create sem malloc */ |
| `Arme/Add/rafaelia_integration.c` | 414 | heap_forbidden_hotpath | if(m) { ws("mx_create BSS: OK (4x4 no-malloc)\n"); } |
| `Arme/Add/rafaelia_integration.c` | 418 | heap_forbidden_hotpath | ws("malloc: ELIMINADO (arena BSS 4MB)\n"); |
| `Arme/Add/rafaelia_jni_direct.c` | 4 | heap_forbidden_hotpath | * ZERO malloc/NewByteArray por chamada |
| `Arme/Add/rafaelia_jni_direct.c` | 54 | heap_forbidden_hotpath | /* ── Estado global do orquestrador (sem malloc) ───────────────────────── */ |
| `Arme/Add/rafaelia_jni_direct.c` | 69 | heap_forbidden_hotpath | /* arena estática de 256KB para JNI — sem malloc */ |
| `Arme/Add/rafaelia_jni_direct.c` | 110 | heap_forbidden_hotpath | * Zero malloc: opera diretamente nos DirectByteBuffer */ |
| `Arme/Add/rafaelia_jni_direct.c` | 134 | failsafe_failover_rollback | /* rollback para init */ |
| `Arme/Add/rafaelia_jni_direct.c` | 238 | heap_forbidden_hotpath | * Escreve JSON de hw_profile em out sem malloc |
| `Arme/Add/rafaelia_jni_direct.c` | 249 | heap_forbidden_hotpath | /* lê dados sem malloc — buffers na stack */ |
| `Arme/Add/rafaelia_master.sh` | 21 | stub_or_placeholder | # SEM PLÁGIO: todo código gerado é original, sem cópia de obras protegidas. |
| `Arme/Add/rafaelia_master.sh` | 111 | heap_forbidden_hotpath | RAFAELIA is a zero-malloc geometric computing system for constrained ARM32 |
| `Arme/Add/rafaelia_master.sh` | 134 | failsafe_failover_rollback | B7: Hz-as-memory · toroidal routing · rollback |
| `Arme/Add/rafaelia_master.sh` | 137 | heap_forbidden_hotpath | GLUE: All modules in single C binary · zero malloc · 42 cycles |
| `Arme/Add/rafaelia_master.sh` | 197 | heap_forbidden_hotpath | # dx/dt = -Lx + α·M(c) — padrão IEEE 754, zero malloc, C11 POSIX |
| `Arme/Add/rafaelia_master.sh` | 212 | heap_forbidden_hotpath | * Sem malloc. Sem dependência de C++. Sem cópia de código protegido. |
| `Arme/Add/rafaelia_master.sh` | 827 | heap_forbidden_hotpath | * Sem malloc. Zero overhead. CRC32C em cada operação de escrita. |
| `Arme/Add/rafaelia_master.sh` | 949 | failsafe_failover_rollback | /* ── Rollback via extra[6,7] ────────────────────────────────────────────── */ |
| `Arme/Add/rafaelia_master.sh` | 1017 | failsafe_failover_rollback | ws("ROLLBACK@cy="); wu(cy); ws("\n"); |
| `Arme/Add/rafaelia_master.sh` | 1075 | missing_or_absence | [ -f "$SRC" ] \|\| { log "missing $SRC"; continue; } |
| `Arme/Add/rafaelia_master.sh` | 1146 | heap_forbidden_hotpath | printf "\nArena usage (zero malloc):\n" |
| `Arme/Add/rafaelia_master.sh` | 1153 | heap_forbidden_hotpath | printf " Total: ~15.7MB peak (zero malloc)\n" |
| `Arme/Add/rafaelia_orchestrator.c` | 9 | heap_forbidden_hotpath | * ZERO malloc — arena estática de 2MB |
| `Arme/Add/rafaelia_orchestrator.c` | 97 | heap_forbidden_hotpath | * ARENA ESTÁTICA — zero malloc |
| `Arme/Add/rafaelia_orchestrator.c` | 660 | heap_forbidden_hotpath | /* Lê carga de CPU de /proc/stat sem malloc |
| `Arme/Add/rafaelia_orchestrator.c` | 855 | failsafe_failover_rollback | /* rollback: rezera camada e recalcula CRC */ |
| `Arme/Add/rafaelia_sigma_omega.c` | 13 | heap_forbidden_hotpath | * Sem malloc. Sem dependência de C++. Sem cópia de código protegido. |
| `Arme/Add/repo_baremetal_orig.c` | 32 | heap_forbidden_hotpath | * - Only stdlib for malloc/free |
| `Arme/Add/repo_baremetal_orig.c` | 473 | heap_forbidden_hotpath | mx_arena_t* arena = (mx_arena_t*)malloc(sizeof(mx_arena_t)); |
| `Arme/Add/repo_baremetal_orig.c` | 475 | heap_forbidden_hotpath | arena->base = (unsigned char*)malloc(capacity_bytes); |
| `Arme/Add/repo_baremetal_orig.c` | 476 | heap_forbidden_hotpath | if (!arena->base) { free(arena); return NULL; } |
| `Arme/Add/repo_baremetal_orig.c` | 496 | heap_forbidden_hotpath | free(arena->base); |
| `Arme/Add/repo_baremetal_orig.c` | 497 | heap_forbidden_hotpath | free(arena); |
| `Arme/Add/repo_baremetal_orig.c` | 529 | heap_forbidden_hotpath | mx_t* m = (mx_t*)malloc(sizeof(mx_t)); |
| `Arme/Add/repo_baremetal_orig.c` | 535 | heap_forbidden_hotpath | m->m = (float*)malloc(bytes); |
| `Arme/Add/repo_baremetal_orig.c` | 537 | heap_forbidden_hotpath | free(m); |
| `Arme/Add/repo_baremetal_orig.c` | 550 | heap_forbidden_hotpath | free(m->m); |
| `Arme/Add/repo_baremetal_orig.c` | 552 | heap_forbidden_hotpath | free(m); |
| `Arme/Add/termux_arm32_build.sh` | 207 | heap_forbidden_hotpath | # GERA: rafaelia_arena.h — arena estática, zero malloc |
| `Arme/Add/termux_arm32_build.sh` | 211 | heap_forbidden_hotpath | * rafaelia_arena.h — arena estática zero malloc |
| `Arme/Add/termux_arm32_build.sh` | 215 | heap_forbidden_hotpath | * RAZÃO: malloc() da Bionic tem overhead de ~100 ciclos + fragmentação. |
| `Arme/Add/termux_arm32_build.sh` | 771 | vectra_risk_marker | attractor_table: |
| `Arme/Add/termux_arm32_build.sh` | 1074 | heap_forbidden_hotpath | printf "\nArena (zero malloc):\n" |
| `Arme/Add/termux_arm32_build.sh` | 1076 | heap_forbidden_hotpath | printf " raf_b1 ASM: sem malloc (puro registradores)\n" |
| `Arme/RAFAELIA_ARKRAF_MASTER.txt` | 135 | heap_forbidden_hotpath | * rafaelia_arena.h — arena estática zero malloc |
| `Arme/RAFAELIA_ARKRAF_MASTER.txt` | 137 | heap_forbidden_hotpath | * RAZÃO: malloc() Bionic ~100 ciclos + fragmentação. |
| `Arme/RAFAELIA_ARKRAF_MASTER.txt` | 158 | failsafe_failover_rollback | * ROLLBACK: g_arena_bump não avança se OOM |
| `Arme/RAFAELIA_ARKRAF_MASTER.txt` | 276 | heap_forbidden_hotpath | * baremetal_nomalloc.h — drop-in zero-malloc para baremetal.h |
| `Arme/RAFAELIA_ARKRAF_MASTER.txt` | 456 | failsafe_failover_rollback | * ROLLBACK: chamador deve chamar g_state_init() se retornar 0 |
| `Arme/RAFAELIA_ARKRAF_MASTER.txt` | 471 | stub_or_placeholder | * INVARIANTE: out[d] ∈ [0,65535] para todo d |
| `Arme/RAFAELIA_ARKRAF_MASTER.txt` | 1088 | failsafe_failover_rollback | if((cy%7)==0&&!bf_verify()){ws("ROLLBACK\n");bf_rollback();} |
| `Arme/RAFAELIA_ARKRAF_MASTER.txt` | 1253 | heap_forbidden_hotpath | * mx_create_bss substitui mx_create com malloc |
| `Arme/RAFAELIA_ARKRAF_MASTER.txt` | 1335 | heap_forbidden_hotpath | /* mx_create sem malloc */ |
| `Arme/RAFAELIA_ARKRAF_MASTER.txt` | 1372 | heap_forbidden_hotpath | ws("mx_bss: ");ws(m?"OK (zero malloc)":"OOM");wn(); |
| `Arme/RAFAELIA_ARKRAF_MASTER.txt` | 1601 | failsafe_failover_rollback | @ — lr salvo → rollback via pop {pc} atomic |
| `Arme/RAFAELIA_ARKRAF_MASTER.txt` | 1793 | heap_forbidden_hotpath | # Android_nomalloc.mk — build NDK sem malloc, page-size 16KB |
| `Arme/RAFAELIA_ARKRAF_MASTER.txt` | 2347 | failsafe_failover_rollback | Garante: snapshot do contexto, rollback via pop {pc} atomic. |
| `Arme/RAFAELIA_ARKRAF_MASTER.txt` | 2348 | failsafe_failover_rollback | SEM esta instrução: sem fail-safe, sem rollback. |
| `Arme/RAFAELIA_CODEX_POLIMATA.txt` | 46 | heap_forbidden_hotpath | [!] Usa malloc() em arena_create — problema em ARM32 embedded |
| `Arme/RAFAELIA_CODEX_POLIMATA.txt` | 51 | failsafe_failover_rollback | [!] Sem commit gate 4 fases — sem rollback de estado |
| `Arme/RAFAELIA_CODEX_POLIMATA.txt` | 54 | heap_forbidden_hotpath | CAMINHO: geolm_full.c → [refactor arena] → [remove malloc] → [Q16.16 completo] |
| `Arme/RAFAELIA_CODEX_POLIMATA.txt` | 69 | heap_forbidden_hotpath | [✓] Zero malloc declarado — usa gctx_t estático |
| `Arme/RAFAELIA_CODEX_POLIMATA.txt` | 98 | stub_or_placeholder | [!] gpuStateNative: stub parcial (não mostrado completo) |
| `Arme/RAFAELIA_CODEX_POLIMATA.txt` | 205 | stub_or_placeholder | 2. Gera classes.dex mínimo (stub Activity carrega .so nativo) |
| `Arme/RAFAELIA_CODEX_POLIMATA.txt` | 219 | stub_or_placeholder | [!] DEX generator: stub mínimo — não gera bytecode real |
| `Arme/RAFAELIA_CODEX_POLIMATA.txt` | 263 | failsafe_failover_rollback | Failsafe e rollback documentados em 3 níveis |
| `Arme/RAFAELIA_CODEX_POLIMATA.txt` | 271 | failsafe_failover_rollback | [✓] Rollback em 3 níveis: log → restaurar → alternativa |
| `Arme/RAFAELIA_CODEX_POLIMATA.txt` | 385 | heap_forbidden_hotpath | GAP B — malloc em geolm_full.c (IMPORTANTE): |
| `Arme/RAFAELIA_CODEX_POLIMATA.txt` | 386 | heap_forbidden_hotpath | arena_create() chama malloc uma vez. |
| `Arme/RAFAELIA_CODEX_POLIMATA.txt` | 387 | heap_forbidden_hotpath | Para Termux ARM32: malloc é lento (~100 ciclos) e pode falhar com OOM. |
| `Arme/RAFAELIA_CODEX_POLIMATA.txt` | 419 | failsafe_failover_rollback | 6. Rollback automático se qualquer módulo falhar |
| `Arme/RAFAELIA_CODEX_POLIMATA.txt` | 435 | heap_forbidden_hotpath | │ .rs → rs2c.sh (ownership → scope + free manual) │ |
| `Arme/RAFAELIA_CODEX_POLIMATA.txt` | 455 | failsafe_failover_rollback | │ Se CRC = 0: corrupção — rollback ao .o anterior │ |
| `Arme/RAFAELIA_CODEX_POLIMATA.txt` | 542 | failsafe_failover_rollback | rollback(module) # restaura último .o válido se existir |
| `Arme/RAFAELIA_CODEX_POLIMATA.txt` | 580 | failsafe_failover_rollback | — salva link register (lr) → rollback automático via pop {pc} |
| `Arme/RAFAELIA_CODEX_POLIMATA.txt` | 613 | failsafe_failover_rollback | ROLLBACK GARANTIDO (qualquer ABI): |
| `Arme/RAFAELIA_CODEX_POLIMATA.txt` | 651 | heap_forbidden_hotpath | [GEOLM-1.5] Zero-malloc completo: |
| `Arme/RAFAELIA_CODEX_POLIMATA.txt` | 652 | heap_forbidden_hotpath | Substituir malloc por arena_bss 64MB |
| `Arme/RAFAELIA_CODEX_POLIMATA.txt` | 696 | failsafe_failover_rollback | ROLLBACK:restaura snapshot@cy-1 */ |
| `Arme/RAFAELIA_CODEX_POLIMATA.txt` | 701 | failsafe_failover_rollback | — O que acontece se falhar? (ROLLBACK) |
| `Arme/RAFAELIA_CODEX_POLIMATA.txt` | 717 | failsafe_failover_rollback | * ROLLBACK: sem efeito colateral — resultado é novo valor, não modifica old |
| `Arme/RAFAELIA_CODEX_POLIMATA.txt` | 742 | failsafe_failover_rollback | — Um rollback (o que fazer se falhar) |
| `Arme/RAFAELIA_CODEX_POLIMATA.txt` | 1098 | stub_or_placeholder | Todo o código compilável no Termux sem root = acessível a qualquer pessoa |
| `Arme/RAFAELIA_MASTER_DOC.txt` | 16 | failsafe_failover_rollback | SEC 07 · COMMIT GATE 4 FASES · ROLLBACK · FAIL-SAFE |
| `Arme/RAFAELIA_MASTER_DOC.txt` | 34 | heap_forbidden_hotpath | inteiramente dentro do Termux ARM32 no Android, sem root, sem malloc no |
| `Arme/RAFAELIA_MASTER_DOC.txt` | 49 | failsafe_failover_rollback | — Fail-safe: CRC ausente = rollback exato ao snapshot |
| `Arme/RAFAELIA_MASTER_DOC.txt` | 194 | heap_forbidden_hotpath | SYS_MMAP2 = 192 · arena sem malloc |
| `Arme/RAFAELIA_MASTER_DOC.txt` | 250 | failsafe_failover_rollback | Rollback: corrompe stack[500], detecta via P1≠P1_orig, restaura. |
| `Arme/RAFAELIA_MASTER_DOC.txt` | 263 | failsafe_failover_rollback | Integra commit gate com snapshot/rollback por core individual. |
| `Arme/RAFAELIA_MASTER_DOC.txt` | 285 | heap_forbidden_hotpath | output via write() direto (sem printf). Zero malloc absoluto. |
| `Arme/RAFAELIA_MASTER_DOC.txt` | 332 | heap_forbidden_hotpath | mx_create_bss() substitui mx_create() com malloc. |
| `Arme/RAFAELIA_MASTER_DOC.txt` | 372 | heap_forbidden_hotpath | mx_create_in_arena(): arena 512KB BSS, sem malloc. |
| `Arme/RAFAELIA_MASTER_DOC.txt` | 381 | heap_forbidden_hotpath | mx_arena_t, mx_t, hw_profile_t. Sem malloc em nenhuma assinatura. |
| `Arme/RAFAELIA_MASTER_DOC.txt` | 448 | heap_forbidden_hotpath | repo_baremetal_orig.c [34KB · 1280 linhas] — original com malloc |
| `Arme/RAFAELIA_MASTER_DOC.txt` | 532 | failsafe_failover_rollback | SEC 07 · COMMIT GATE 4 FASES · ROLLBACK · FAIL-SAFE |
| `Arme/RAFAELIA_MASTER_DOC.txt` | 552 | failsafe_failover_rollback | → Se inválido: rollback automático para último COMMIT |
| `Arme/RAFAELIA_MASTER_DOC.txt` | 563 | failsafe_failover_rollback | Rollback: restaura e recalcula P0 e P1. |
| `Arme/RAFAELIA_MASTER_DOC.txt` | 724 | failsafe_failover_rollback | ROLLBACK: se erro em instrução K: |
| `Arme/RAFAELIA_MASTER_DOC.txt` | 730 | failsafe_failover_rollback | Derivada de uma instrução: instrução inversa (rollback) |
| `Arme/RAFAELIA_MASTER_DOC.txt` | 799 | failsafe_failover_rollback | │ Rollback se CRC difere do esperado │ |
| `Arme/RAFAELIA_MASTER_DOC.txt` | 805 | heap_forbidden_hotpath | Rust → C: ownership → análise de escopo + free manual |
| `Arme/RAFAELIA_MASTER_DOC.txt` | 840 | failsafe_failover_rollback | Isso garante que o estado pré-chamada é restaurável (rollback) |
| `Arme/RAFAELIA_MASTER_DOC.txt` | 878 | failsafe_failover_rollback | msr cpsr,r0 → restaura flags (rollback de Z) |
| `Arme/RAFAELIA_MASTER_DOC.txt` | 933 | heap_forbidden_hotpath | /// Arena estática — zero malloc, zero heap |
| `Arme/RAFAELIA_MASTER_DOC.txt` | 1190 | heap_forbidden_hotpath | Sem dependências externas. Sem malloc no código gerado. |
| `Arme/RAFAELIA_MASTER_DOC.txt` | 1504 | failsafe_failover_rollback | Correção QEC → Paridade P0+P1 + rollback (análogo a código de Shor) |
| `Arme/RAF_GENESIS.txt` | 290 | heap_forbidden_hotpath | * ZERO malloc = gota (não fragmenta o espaço) |
| `Arme/RAF_PMU_LIVE.txt` | 794 | heap_forbidden_hotpath | * Tudo em BSS arena. Sem malloc. Sem overhead de scheduler. |
| `Arme/RAF_PMU_LIVE.txt` | 942 | heap_forbidden_hotpath | ws("Zero malloc: OK\nZero overhead: OK\n"); |
| `Arme/RAF_STATECOMP.txt` | 209 | heap_forbidden_hotpath | /* Arena sem malloc */ |
| `Arme/RAF_STATECOMP.txt` | 840 | failsafe_failover_rollback | * - Última instrução: pop {r4,r5,r6,r7,pc} (rollback atômico) |
| `Arme/RAF_STATECOMP.txt` | 1123 | failsafe_failover_rollback | emit_fmt(ctx," pop {{r4, r5, r6, r7, pc}} @ #RET rollback+return\n"); |
| `Arme/RAF_STATECOMP.txt` | 1286 | failsafe_failover_rollback | emit_fmt(ctx," beq .gate_rollback_%u @ rollback\n",lbl); |
| `Arme/RAF_STATECOMP.txt` | 1296 | failsafe_failover_rollback | emit_fmt(ctx,".gate_rollback_%u: @ ROLLBACK: restaura snapshot\n",lbl); |
| `Arme/RAF_STATECOMP.txt` | 1358 | failsafe_failover_rollback | emit_str(ctx," @ instrução 1: genérica, fail-safe, rollback via pop{pc}\n\n"); |
| `Arme/RAF_STATECOMP.txt` | 1570 | heap_forbidden_hotpath | char *buf=(char*)malloc((size_t)sz+1); |
| `Arme/RAF_STATECOMP.txt` | 1573 | heap_forbidden_hotpath | if(n<=0){free(buf);return NULL;} |
| `Arme/RAF_STATECOMP.txt` | 1581 | heap_forbidden_hotpath | sc_ctx_t *ctx=(sc_ctx_t*)calloc(1,sizeof(sc_ctx_t)); |
| `Arme/RAF_STATECOMP.txt` | 1677 | heap_forbidden_hotpath | free(ctx); |
| `Arme/RAF_STATECOMP.txt` | 1687 | heap_forbidden_hotpath | sc_ctx_t *ctx=(sc_ctx_t*)calloc(1,sizeof(sc_ctx_t)); |
| `Arme/RAF_STATECOMP.txt` | 1688 | heap_forbidden_hotpath | if(!ctx){free(src);return -1;} |
| `Arme/RAF_STATECOMP.txt` | 1692 | heap_forbidden_hotpath | free(src); |
| `Arme/RAF_STATECOMP.txt` | 1700 | heap_forbidden_hotpath | free(ctx);return -1; |
| `Arme/RAF_STATECOMP.txt` | 1707 | heap_forbidden_hotpath | if(ee<0){free(ctx);return -1;} |
| `Arme/RAF_STATECOMP.txt` | 1713 | heap_forbidden_hotpath | free(ctx); |
| `Arme/RAF_STATECOMP.txt` | 1769 | failsafe_failover_rollback | * - Rollback intrínseco: CRC chain detecta corrupção em O(1) |
| `Arme/RAF_STATECOMP.txt` | 1861 | failsafe_failover_rollback | /* ── Rollback da fita ────────────────────────────────────────────────── */ |
| `Arme/RAF_STATECOMP.txt` | 1886 | failsafe_failover_rollback | /* snapshot para rollback */ |
| `Arme/RAF_STATECOMP.txt` | 1902 | failsafe_failover_rollback | return -1; /* rollback */ |
| `Arme/RAF_STATECOMP.txt` | 2111 | heap_forbidden_hotpath | sc_ctx_t *ctx=(sc_ctx_t*)calloc(1,sizeof(sc_ctx_t)); |
| `Arme/RAF_STATECOMP.txt` | 2136 | heap_forbidden_hotpath | free(ctx); |
| `Arme/RAF_STATECOMP.txt` | 2380 | stub_or_placeholder | - SHADOW documentado em todo comentário inline |
| `Arme/RAF_STATECOMP.txt` | 2757 | failsafe_failover_rollback | "@ LOAD→PROC→VERIFY→COMMIT\nldmia r12,{r4,r5,r6,r7}\nbl g_crc32\ncmp r0,#0\nbeq .rollback", |
| `Arme/RAF_STATECOMP.txt` | 2758 | failsafe_failover_rollback | "if(!commit_gate(&g_state)){rollback(&g_state);}", |
| `Arme/arwiteto_script.sh` | 5 | failsafe_failover_rollback | # Plug-n-play · Watchdog · Rollback · Industrial Benchmark · BBS UI |
| `Arme/arwiteto_script.sh` | 323 | failsafe_failover_rollback | # Timeout — força rollback |
| `Arme/arwiteto_script.sh` | 324 | failsafe_failover_rollback | printf '\n[WATCHDOG] TIMEOUT %ds — iniciando rollback\n' \ |
| `Arme/arwiteto_script.sh` | 347 | failsafe_failover_rollback | # [6] ROLLBACK MODULE |
| `Arme/arwiteto_script.sh` | 373 | failsafe_failover_rollback | log WRN "Rollback restaurado de: $dir" |
| `Arme/arwiteto_script.sh` | 697 | missing_or_absence | # HF-01: stdint.h missing in rafaelia_gpu.h |
| `Arme/arwiteto_script.sh` | 725 | failsafe_failover_rollback | # HF-06: rollback condition impossível em rafaelia_glue.c |
| `Arme/arwiteto_script.sh` | 729 | failsafe_failover_rollback | { log OK "HF-06: condição rollback corrigida em rafaelia_glue.c"; hf_count=$((hf_count+1)); } |
| `Arme/arwiteto_script.sh` | 898 | missing_or_absence | local missing=0 |
| `Arme/arwiteto_script.sh` | 900 | missing_or_absence | pkg_need "clang" "clang" \|\| missing=$((missing+1)) |
| `Arme/arwiteto_script.sh` | 901 | missing_or_absence | pkg_need "binutils" "objcopy" \|\| missing=$((missing+1)) |
| `Arme/arwiteto_script.sh` | 902 | missing_or_absence | pkg_need "awk" "awk" \|\| missing=$((missing+1)) |
| `Arme/arwiteto_script.sh` | 903 | missing_or_absence | pkg_need "sed" "sed" \|\| missing=$((missing+1)) |
| `Arme/arwiteto_script.sh` | 904 | missing_or_absence | pkg_need "dd" "dd" \|\| missing=$((missing+1)) |
| `Arme/arwiteto_script.sh` | 906 | missing_or_absence | if [ "$missing" -gt 0 ] && [ "$IS_TERMUX" = "1" ]; then |
| `Arme/arwiteto_script.sh` | 907 | missing_or_absence | log WRN "$missing pacotes ausentes — tentando instalar..." |
| `Arme/arwiteto_script.sh` | 911 | missing_or_absence | [ "$missing" -gt 0 ] && log WRN "Alguns pacotes ausentes — compilação pode falhar" |
| `Arme/arwiteto_script.sh` | 961 | failsafe_failover_rollback | -m rollback Lista e restaura checkpoints |
| `Arme/arwiteto_script.sh` | 1053 | failsafe_failover_rollback | rollback) |
| `Arme/arwiteto_script.sh` | 1055 | failsafe_failover_rollback | log INF "Para restaurar: $0 -m rollback (restaura o mais recente)" |
| `Arme/compilador_asm_legacy.sh` | 60 | heap_forbidden_hotpath | * [#T05] Arena: alocador bump sem malloc |
| `Arme/compilador_asm_legacy.sh` | 456 | heap_forbidden_hotpath | * [#LX07] Zero malloc: tokens apontam para o buffer de entrada (slice) |
| `Arme/compilador_asm_legacy.sh` | 803 | heap_forbidden_hotpath | * [#AST03] Máximo de filhos por nó: 8 (sem malloc, arena only) |
| `Arme/compilador_asm_legacy.sh` | 855 | heap_forbidden_hotpath | /* Pool de nós — sem malloc */ |
| `Arme/compilador_asm_legacy.sh` | 1070 | heap_forbidden_hotpath | * [#CG01] Buffer de saída estático (sem malloc): 1MB |
| `Arme/conceitos_mvp.txt` | 18 | stub_or_placeholder | — Referência de ASM sem stub sem malloc |
| `Arme/conceitos_mvp.txt` | 18 | heap_forbidden_hotpath | — Referência de ASM sem stub sem malloc |
| `Arme/conceitos_mvp.txt` | 73 | heap_forbidden_hotpath | — Problema: usa malloc, usa float, usa libc |
| `Arme/conceitos_mvp.txt` | 83 | heap_forbidden_hotpath | CoreMark: 18.000 pts — com malloc, com libc |
| `Arme/conceitos_mvp.txt` | 84 | heap_forbidden_hotpath | RAFAELIA fraf: 0.81 ns/op — sem libc, Q16, zero malloc |
| `Arme/conceitos_mvp.txt` | 86 | heap_forbidden_hotpath | RAFAELIA arena: 2-3 ns/alloc — 25× mais rápido que CoreMark malloc |
| `Arme/conceitos_mvp.txt` | 87 | heap_forbidden_hotpath | RAFAELIA fsm: 2 ns/trans — lookup table, branch-free |
| `Arme/conceitos_mvp.txt` | 90 | heap_forbidden_hotpath | CoreMark inclui fricção por definição (usa libc malloc). |
| `Arme/conceitos_mvp.txt` | 104 | heap_forbidden_hotpath | malloc(64) → 100-300ns (lock+bins+mmap+metadata) |
| `Arme/conceitos_mvp.txt` | 108 | failsafe_failover_rollback | alloca(64) → 1ns (adjust SP = 1 instrução, mas sem rollback) |
| `Arme/conceitos_mvp.txt` | 159 | heap_forbidden_hotpath | [T01] BUMP ALLOCATOR vs malloc |
| `Arme/conceitos_mvp.txt` | 162 | heap_forbidden_hotpath | GANHO: 25-60× \| CUSTO: sem free() individual |
| `Arme/conceitos_mvp.txt` | 165 | heap_forbidden_hotpath | [T02] ARENA MARK/RESTORE vs malloc/free par |
| `Arme/conceitos_mvp.txt` | 166 | heap_forbidden_hotpath | CAMINHO CORTADO: rastreamento de ponteiros, free() individual |
| `Arme/conceitos_mvp.txt` | 168 | heap_forbidden_hotpath | GANHO: equivalente a free() em O(1) sem overhead |
| `Arme/conceitos_mvp.txt` | 169 | failsafe_failover_rollback | APLICAÇÃO: funções recursivas, tentativas com rollback |
| `Arme/conceitos_mvp.txt` | 171 | heap_forbidden_hotpath | [T03] STACK ALLOC vs heap (alloca vs malloc) |
| `Arme/conceitos_mvp.txt` | 183 | heap_forbidden_hotpath | CAMINHO CORTADO: mmap/malloc para pools de objetos |
| `Arme/conceitos_mvp.txt` | 190 | heap_forbidden_hotpath | GANHO: O(1) alloc/free sem fragmentação para tamanho único |
| `Arme/conceitos_mvp.txt` | 328 | stub_or_placeholder | TÉCNICA: LTO analisa todo o programa no link, inline cross-TU |
| `Arme/conceitos_mvp.txt` | 342 | stub_or_placeholder | APLICAÇÃO: integridade de sessão local (HashVivo placeholder) |
| `Arme/conceitos_mvp.txt` | 366 | failsafe_failover_rollback | CAMINHO CORTADO: cópias profundas de estado para rollback |
| `Arme/conceitos_mvp.txt` | 382 | heap_forbidden_hotpath | NOMALLOC = sem malloc, sem heap, sem brk(), sem mmap para dados |
| `Arme/conceitos_mvp.txt` | 388 | heap_forbidden_hotpath | 3. Configura stdio (FILE* buffers = malloc interno) |
| `Arme/conceitos_mvp.txt` | 538 | failsafe_failover_rollback | ROLLBACK DE FLAGS (failsafe): |
| `Arme/conceitos_mvp.txt` | 539 | failsafe_failover_rollback | static u32 G_FLAGS_PREV = 0; /* snapshot para rollback */ |
| `Arme/conceitos_mvp.txt` | 544 | failsafe_failover_rollback | /* Macro de operação com rollback automático */ |
| `Arme/conceitos_mvp.txt` | 573 | stub_or_placeholder | — Todo dado crítico deve caber em L1 (64KB típico) |
| `Arme/conceitos_mvp.txt` | 676 | failsafe_failover_rollback | ROLLBACK INTEGRADO: |
| `Arme/conceitos_mvp.txt` | 678 | failsafe_failover_rollback | Se operação falha: ARENA RESTORE + FLAGS ROLLBACK |
| `Arme/documentacao_tecnica_algoritmos.md` | 167 | missing_or_absence | - Ausência de índice canônico do diretório com classificação “executável vs especificação”. |
| `Arme/estado_modelo_temporal.md` | 87 | failsafe_failover_rollback | /* [#B02] Estrutura TTL com checkpoint para rollback */ |
| `Arme/estado_modelo_temporal.md` | 95 | failsafe_failover_rollback | u64 checkpoint; /* snapshot de estado para rollback */ |
| `Arme/estado_modelo_temporal.md` | 157 | failsafe_failover_rollback | /* [#B07] Checkpoint/Rollback de estado */ |
| `Arme/estado_modelo_temporal.md` | 391 | heap_forbidden_hotpath | * [#A64-07] CSEL: seleção condicional branch-free em 1 ciclo |
| `Arme/estado_modelo_temporal.md` | 545 | heap_forbidden_hotpath | /* [#A64-S] CSEL — seleção condicional branch-free */ |
| `Arme/estado_modelo_temporal.md` | 617 | heap_forbidden_hotpath | * 8 iterações unrolled — elimina loop overhead, branch-free via conditional XOR |
| `Arme/estado_modelo_temporal.md` | 717 | stub_or_placeholder | /* [0..31] Hot: acessados em todo step */ |
| `Arme/estado_modelo_temporal.md` | 881 | failsafe_failover_rollback | * [#MC06] Rollback demonstrado em caso de CORRUPT |
| `Arme/estado_modelo_temporal.md` | 1095 | failsafe_failover_rollback | /* --- FASE 6: Rollback demonstrado --- */ |
| `Arme/estado_modelo_temporal.md` | 1096 | failsafe_failover_rollback | out("\n-- FASE 6: ROLLBACK DEMO --\n"); |
| `Arme/estado_modelo_temporal.md` | 1102 | failsafe_failover_rollback | /* Rollback: restaura hash_chain */ |
| `Arme/estado_modelo_temporal.md` | 1104 | failsafe_failover_rollback | out(" Rollback: hash_chain restaurado\n"); |
| `Arme/estado_modelo_temporal.md` | 1191 | failsafe_failover_rollback | hdr "S08 · BUILD SCRIPT COM FAILSAFE E ROLLBACK" |
| `Arme/estado_nucleo.md` | 842 | heap_forbidden_hotpath | analogRead 2000 ciclos ADC free-running 250× |
| `Arme/estado_nucleo.md` | 847 | heap_forbidden_hotpath | malloc() 200 ciclos bump arena (2 instr) 100× |
| `Arme/pomeg.txt` | 1 | failsafe_failover_rollback | x sem root → rodar com failsafe e rollback automático → e ao final deixar o binário disponível para qualquer pessoa redistribuir como "partícula Ω própria".Gerar script ARM32 Termu |
| `Arme/pomeg.txt` | 6 | failsafe_failover_rollback | # Filosofia: coexistência harmônica · failsafe · rollback · partícula Ω |
| `Arme/pomeg.txt` | 12 | failsafe_failover_rollback | # Simbiose: os módulos coexistem sem conflito. Rollback se algo falha. |
| `Arme/pomeg.txt` | 20 | failsafe_failover_rollback | # --clean remove arquivos temporários com rollback seguro |
| `Arme/pomeg.txt` | 25 | failsafe_failover_rollback | # [#02 FAILSAFE E ROLLBACK] |
| `Arme/pomeg.txt` | 28 | failsafe_failover_rollback | # 2. Estado anterior é restaurado (rollback) |
| `Arme/pomeg.txt` | 53 | failsafe_failover_rollback | readonly BAK_DIR="${WORK_DIR}/backup" # rollback point |
| `Arme/pomeg.txt` | 78 | failsafe_failover_rollback | echo ' ║ Coexistência Harmônica · Failsafe · Rollback ║' |
| `Arme/pomeg.txt` | 85 | failsafe_failover_rollback | # ── SISTEMA DE ROLLBACK ────────────────────────────────────────────────────── |
| `Arme/pomeg.txt` | 86 | failsafe_failover_rollback | # [#ROLLBACK] Cada operação crítica cria um ponto de restauração |
| `Arme/pomeg.txt` | 90 | failsafe_failover_rollback | # Adiciona uma função de rollback à pilha |
| `Arme/pomeg.txt` | 96 | failsafe_failover_rollback | warn "Iniciando rollback..." |
| `Arme/pomeg.txt` | 99 | failsafe_failover_rollback | log "Rollback: ${ROLLBACK_STACK[$i]}" |
| `Arme/pomeg.txt` | 102 | failsafe_failover_rollback | warn "Rollback completo. Estado anterior restaurado." |
| `Arme/pomeg.txt` | 208 | failsafe_failover_rollback | # ── INSTALAÇÃO DE DEPENDÊNCIAS COM FAILSAFE ────────────────────────────────── |
| `Arme/pomeg.txt` | 209 | failsafe_failover_rollback | # [#INSTALL] Instala somente o necessário, com rollback se falhar |
| `Arme/pomeg.txt` | 247 | failsafe_failover_rollback | # Failsafe: tenta instalar, não falha se um pacote não existir |
| `Arme/pomeg.txt` | 253 | failsafe_failover_rollback | # Rollback: se algo foi instalado e o build falhar, não desinstala |
| `Arme/pomeg.txt` | 270 | failsafe_failover_rollback | # Snapshot do que existia antes (para rollback) |
| `Arme/pomeg.txt` | 545 | heap_forbidden_hotpath | /* raf_arena_arm32.h — Bump allocator ARM32 sem malloc sem heap |
| `Arme/pomeg.txt` | 548 | failsafe_failover_rollback | * [#AR03] Rollback via mark/restore — crucial para uso em Termux |
| `Arme/pomeg.txt` | 643 | heap_forbidden_hotpath | /* 8 iterações unrolled — branch-free via conditional XOR */ |
| `Arme/pomeg.txt` | 725 | failsafe_failover_rollback | * [#MAIN03] Failsafe: cada fase verifica resultado antes de prosseguir |
| `Arme/pomeg.txt` | 851 | heap_forbidden_hotpath | raf_puts("zero-libc zero-heap zero-malloc\n"); |
| `Arme/pomeg.txt` | 932 | failsafe_failover_rollback | # ── COMPILAÇÃO COM FAILSAFE E ROLLBACK ────────────────────────────────────── |
| `Arme/pomeg.txt` | 939 | failsafe_failover_rollback | # Backup dos binários existentes (rollback point) |
| `Arme/pomeg.txt` | 1047 | failsafe_failover_rollback | # ── EXECUÇÃO COM FAILSAFE ──────────────────────────────────────────────────── |
| `Arme/pomeg.txt` | 1196 | failsafe_failover_rollback | # Rollback: faz backup antes de limpar |
| `Arme/rafaelia_bare_hardware_v2.txt` | 232 | heap_forbidden_hotpath | ADTS: trigger (0=manual, 1=free running, 5=Timer0 OvF, etc) */ |
| `Arme/rafaelia_bare_hardware_v2.txt` | 234 | heap_forbidden_hotpath | /* TÉCNICA 8: ADC free-running @ 125kHz, resultado sempre pronto */ |
| `Arme/rafaelia_bare_hardware_v2.txt` | 240 | heap_forbidden_hotpath | /* Ler ADC free-running — resultado disponível a cada 125kHz */ |
| `Arme/rafaelia_bare_hardware_v2.txt` | 941 | heap_forbidden_hotpath | ADC free-running @ 125kHz, resultado DMA para buffer circular |
| `Arme/rafaelia_bare_hardware_v2.txt` | 995 | heap_forbidden_hotpath | [ADC free-running @ 125kHz] |
| `Arme/rafaelia_bare_hardware_v2.txt` | 1027 | stub_or_placeholder | * TODO registrador tem um endereço. Todo bit tem significado. |
| `Arme/rafaelia_bare_hardware_v2.txt` | 1044 | heap_forbidden_hotpath | * - K-means em Q8 sem malloc |
| `Arme/rafaelia_bare_hardware_v2.txt` | 1058 | missing_or_absence | * O silício conhece tensão e ausência de tensão. |
| `Arme/rafaelia_master.txt` | 450 | heap_forbidden_hotpath | * [#UC01] Zero stdlib. Zero malloc. Zero float. Zero nome de variável desnecessário. |
| `Arme/rafaelia_master.txt` | 826 | heap_forbidden_hotpath | * Tamanho: <400 bytes Flash, 0 bytes SRAM dinâmica (zero heap zero malloc) |
| `Arme/rafaelia_master.txt` | 896 | heap_forbidden_hotpath | /* [#ARD07] ADC free-running @ 125kHz */ |
| `Arme/rafaelia_sementes_v1.txt` | 183 | vectra_risk_marker | §S10 KAT/NetKAT BitOmega: primeira aplicação a scheduler móvel |
| `Arme/rafaelia_sementes_v1.txt` | 262 | stub_or_placeholder | P=NP sse todo problema NP tem órbita de período polinomial em T^n |
| `Asm2.md` | 122 | failsafe_failover_rollback | #define P_ROLLB_FR 27u /* rollback frequency */ |
| `Asm2.md` | 140 | heap_forbidden_hotpath | /* Arena bump sem malloc */ |
| `Asm2.md` | 428 | heap_forbidden_hotpath | * [P21] Branch-free em todas as operações críticas |
| `Asm2.md` | 530 | failsafe_failover_rollback | * [P33] Rollback: checkpoint antes de cada benchmark |
| `Asm2.md` | 531 | failsafe_failover_rollback | * [P34] Failsafe: TTL 8 com RETRY em caso de spike |
| `Asm2.md` | 540 | heap_forbidden_hotpath | /* Insertion sort O(n²) na stack — sem qsort sem malloc */ |
| `Asm2.md` | 742 | failsafe_failover_rollback | /* ── ROLLBACK + FAILSAFE ─────────────────────────────────────────────── */ |
| `Asm2.md` | 752 | failsafe_failover_rollback | _G_TOP=_chk; /* rollback arena */ \ |
| `Asm2.md` | 756 | failsafe_failover_rollback | if(!result.valid){PS(" [FAILSAFE: usando valores defaults]\n"); \ |
| `Asm2.md` | 919 | failsafe_failover_rollback | /* Executa 8 benchmarks com failsafe */ |
| `BENCHMARKS_COMPARISON.md` | 397 | heap_forbidden_hotpath | \| Criação/Destruição \| 4 \| create, free, copy, clone \| |
| `BOOSTERS.md` | 245 | heap_forbidden_hotpath | - **Zero Dependências**: Apenas libc sistema (malloc, free) |
| `BOOTSTRAP_LOWLEVEL_RAFAELIA.txt` | 8 | stub_or_placeholder | - wojcikiewicz17/Vectras-VM-Android/rmr_lowlevel.h (forward stub root) |
| `BOOTSTRAP_LOWLEVEL_RAFAELIA.txt` | 36 | heap_forbidden_hotpath | NOTA: Nenhuma função de libc é chamada. Sem malloc/free/memcpy/printf. |
| `BOOTSTRAP_LOWLEVEL_RAFAELIA.txt` | 57 | stub_or_placeholder | * Invariante: todo bloco com Witness=false é DESCARTADO antes de computar. |
| `BOOTSTRAP_LOWLEVEL_RAFAELIA.txt` | 59 | heap_forbidden_hotpath | * Nenhuma dependência externa. Nenhum malloc. Nenhum heap. Stack pura. |
| `BOOTSTRAP_LOWLEVEL_RAFAELIA.txt` | 248 | heap_forbidden_hotpath | SEÇÃO 3 — ARENA ESTÁTICA (sem malloc, sem heap, sem fragmentação) |
| `BOOTSTRAP_LOWLEVEL_RAFAELIA.txt` | 257 | heap_forbidden_hotpath | * Reset total ou por mark/restore — sem free individual */ |
| `BOOTSTRAP_LOWLEVEL_RAFAELIA.txt` | 565 | heap_forbidden_hotpath | /* Buffer de blocos — BSS estático, sem malloc */ |
| `BOOTSTRAP_LOWLEVEL_RAFAELIA.txt` | 709 | heap_forbidden_hotpath | * Sem malloc. Buffer de destino fornecido pelo chamador (stack ou arena). |
| `BOOTSTRAP_LOWLEVEL_RAFAELIA.txt` | 764 | heap_forbidden_hotpath | * ZERO malloc. ZERO fragmentação. Todas as estruturas em BSS estático. */ |
| `BOOTSTRAP_LOWLEVEL_RAFAELIA.txt` | 864 | heap_forbidden_hotpath | * Cada etapa: sem heap, sem malloc, operações em stack ou arena BSS |
| `BOOTSTRAP_LOWLEVEL_RAFAELIA.txt` | 1203 | heap_forbidden_hotpath | * - Sem heap. Sem malloc. Tudo na arena BSS ou stack. */ |
| `BOOTSTRAP_LOWLEVEL_RAFAELIA.txt` | 1544 | heap_forbidden_hotpath | /* argv na stack — sem malloc */ |
| `BOOTSTRAP_LOWLEVEL_RAFAELIA.txt` | 1602 | heap_forbidden_hotpath | * Sem malloc: buffer de KV-cache e pesos em arena BSS |
| `BOOTSTRAP_LOWLEVEL_RAFAELIA.txt` | 1710 | heap_forbidden_hotpath | * - Sem malloc, sem libc, sem abstração */ |
| `BOOTSTRAP_LOWLEVEL_RAFAELIA.txt` | 1963 | stub_or_placeholder | * rmr_lowlevel.h → stub → engine/rmr/include/rmr_lowlevel.h |
| `Browser.sh` | 78 | failsafe_failover_rollback | #define FL_ERROR 0x40u /* 01000000: estado de erro (rollback) */ |
| `Browser.sh` | 95 | heap_forbidden_hotpath | /* ── ARENA 256KB sem malloc ──────────────────────────────────────────── */ |
| `Browser.sh` | 127 | failsafe_failover_rollback | /* Retry/Rollback TTL */ |
| `Browser.sh` | 352 | stub_or_placeholder | *p++=0;*p++=0;*p++=0; /* length placeholder (3 bytes) */ |
| `Browser.sh` | 673 | failsafe_failover_rollback | * [R32] Failsafe: TTL 3 tentativas com rollback de estado |
| `Browser.sh` | 807 | failsafe_failover_rollback | * [R35] Rollback: GM/GRS de arena em caso de erro |
| `Browser.sh` | 808 | failsafe_failover_rollback | * [R36] Failsafe: TTL 3 tentativas por fase |
| `BugOrAdd/42.c` | 216 | heap_forbidden_hotpath | unsigned char *image = (unsigned char*)malloc(img_size); |
| `BugOrAdd/42.c` | 282 | heap_forbidden_hotpath | free(image); |
| `BugOrAdd/Android_nomalloc.mk` | 2 | heap_forbidden_hotpath | # RAFAELIA — build sem malloc, page-size 16KB, zero overhead |
| `BugOrAdd/Android_nomalloc.mk` | 19 | heap_forbidden_hotpath | # Zero malloc: -fno-exceptions remove overhead de C++ EH |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 179 | failsafe_failover_rollback | uint32_t rollback=0, stuck=0, last_crc=0; |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 205 | failsafe_failover_rollback | rollback++; |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 213 | failsafe_failover_rollback | rollback, |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 253 | failsafe_failover_rollback | printf("rollback=%u stuck=%u coherence=%.3f\n", |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 254 | failsafe_failover_rollback | rollback, stuck, (double)coh/65536.0); |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 256 | failsafe_failover_rollback | if(rollback==0 && stuck==0 && coh>ONE_Q16*3/4) |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 356 | failsafe_failover_rollback | static void report(const char *name, uint64_t *s, uint32_t rollback, uint32_t stuck, uint32_t coh){ |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 375 | failsafe_failover_rollback | printf("rollback=%u stuck=%u coherence=%.3f\n", rollback, stuck, (double)coh/65536.0); |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 510 | failsafe_failover_rollback | uint32_t rollback = 0; |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 581 | failsafe_failover_rollback | rollback++; |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 588 | failsafe_failover_rollback | "round=%02d ns=%llu MB/s=%.2f coherence=%.3f rollback=%u stuck=%u\n", |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 593 | failsafe_failover_rollback | rollback, |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 632 | failsafe_failover_rollback | ((double)(ROUNDS - rollback + 1) * |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 659 | failsafe_failover_rollback | printf("rollback=%u stuck=%u\n", |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 660 | failsafe_failover_rollback | rollback, |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 744 | failsafe_failover_rollback | uint32_t rollback = 0; |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 819 | failsafe_failover_rollback | rollback++; |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 826 | failsafe_failover_rollback | "round=%02d ns=%llu MB/s=%.2f crc=%08x coherence=%.3f rollback=%u stuck=%u\n", |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 832 | failsafe_failover_rollback | rollback, |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 856 | failsafe_failover_rollback | ((double)(ROUNDS - rollback + 1) * |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 879 | failsafe_failover_rollback | printf("rollback=%u stuck=%u\n", |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 880 | failsafe_failover_rollback | rollback, |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 974 | failsafe_failover_rollback | uint32_t rollback = 0; |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 1024 | failsafe_failover_rollback | rollback++; |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 1034 | failsafe_failover_rollback | "round=%02d ns=%llu MB/s=%.2f coherence=%.3f rollback=%u stuck=%u\n", |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 1039 | failsafe_failover_rollback | rollback, |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 1068 | failsafe_failover_rollback | ((double)(ROUNDS - rollback + 1) * |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 1092 | failsafe_failover_rollback | printf("rollback=%u stuck=%u\n", |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 1093 | failsafe_failover_rollback | rollback, |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 1162 | failsafe_failover_rollback | uint32_t stuck = 0, rollback = 0; |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 1197 | failsafe_failover_rollback | rollback++; |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 1207 | failsafe_failover_rollback | printf("round=%02d ns=%llu MB/s=%.2f crc=%08x fnv=%016llx coherence=%.3f stuck=%u rollback=%u\\n", |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 1208 | failsafe_failover_rollback | r, (unsigned long long)dt, mbps, crc, (unsigned long long)fnv, coh, stuck, rollback); |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 1214 | failsafe_failover_rollback | double mcr = ((double)(ROUNDS - rollback + 1) * ((double)ema_coherence/65536.0)) / (1.0 + jitter + stuck); |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 1220 | failsafe_failover_rollback | printf("rollback=%u stuck=%u\\n", rollback, stuck); |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 1225 | failsafe_failover_rollback | else puts("REGIME: INSTAVEL / rollback-stuck dominando"); |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 1323 | stub_or_placeholder | // placeholder |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 1352 | stub_or_placeholder | // Processa todo o cubo BitRaf aplicando uma das operações acima |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 1439 | heap_forbidden_hotpath | free(cube); |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 2860 | stub_or_placeholder | // Todo o estado da Matrix (64 dimensões) vive dentro de q0-q15. |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 3001 | heap_forbidden_hotpath | free(block); |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 3208 | heap_forbidden_hotpath | free(block); |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 3304 | heap_forbidden_hotpath | free(fabric); |
| `BugOrAdd/DOSSIÊ_RAFAELIA_VECTRA_C_ASM.txt` | 4133 | failsafe_failover_rollback | RAFAELIA EDGE V2\nARM32 \| Android \| low-memory \| cache-aware\nbuffer=256 KB rounds=48 warmup=8\n\nround=00 ns=5057000 MB/s=98.87 coherence=1.000 rollback=0 stuck=0 |
