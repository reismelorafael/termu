# RAFAELIA Audit — Current Repo

- **Data**: 2026-05-10
- **Repo atual**: `termux-app-rafacodephi`
- **Branch atual**: `work`
- **Commit atual (antes deste patch final)**: `7e4b4fe...`

## Build baseline e correções aplicadas
- `./scripts/ci_android_preflight.sh`: passou e preparou `local.properties`.
- `./gradlew tasks --all`: passou após preflight.
- `./gradlew :app:assembleDebug`: falhou em cadeia por múltiplas causas-raiz e foi tratado incrementalmente.

### Causas-raiz encontradas e tratadas
1. `scripts/rewrite_bootstrap.py` dependia de utilitário externo `file` e quebrava em ambientes mínimos.
   - **Correção**: fallback quando `file` está ausente.
2. Reescrita de texto duplicava package name (`com.termux.rafacodephi.rafacodephi`) por replace ingênuo.
   - **Correção**: substituição com regex protegida.
3. Validação de runtime assumia caminhos rígidos (`bin/sh`, `bin/pkg`) e sem tolerância de layout.
   - **Correção**: candidatos de shell/pkg ampliados para `bin/*` e `usr/bin/*`.
4. `TEXT_NAMES` tratava `apt` como texto e tentava validar binário ELF como arquivo textual.
   - **Correção**: removido `apt` de `TEXT_NAMES`.
5. Bloqueio de prefixo legado em ELF era aplicado sempre, mesmo fora de modo estrito.
   - **Correção**: bloqueio agora só em `--strict-elf-prefix-check`; fora disso vira relatório não bloqueante.
6. Validação Gradle de bootstrap reescrito exigia `bin/sh`/`bin/pkg` exatos.
   - **Correção**: validação alinhada com matriz de candidatos de shell/pkg.
7. Build app tinha strings ausentes em `root_preferences.xml`.
   - **Correção**: adicionadas `industrial_diagnostics_title` e `industrial_diagnostics_summary`.
8. Build Java falhava por uso inválido de `Logger.logError(..., Throwable)`.
   - **Correção**: adaptado para assinatura existente.
9. Build Java falhava por `BuildConfig` sem campos usados em `SystemAuditActivity`.
   - **Correção**: adicionados `CONFIGURED_MIN_SDK` e `SUPPORTED_APK_ABIS` em `buildConfigField`.
10. Repropagação em modo estrito fazia `throw t` com `Throwable` checado.
   - **Correção**: agora lança `RuntimeException(..., t)`.

## Estado atual medido
- `:app:rewriteBootstraps` e `:app:validateRewrittenBootstraps` avançaram após correções.
- `./gradlew :app:compileDebugJavaWithJavac` ainda estava em ciclo de correção no último run desta execução (não houve confirmação final de `assembleDebug` concluído).
- Release assinado **não validado** por ausência de material de assinatura no ambiente.
- APK arm32/arm64 em device real **não validado** neste ambiente.

## Riscos restantes
- Alto volume de ocorrências de prefixo legado em ELF upstream (reportado em modo não-bloqueante); para trilha estrita, depende de estratégia dedicada de saneamento/allowlist por contrato.
- Falta de validação em hardware real para arm32/arm64 e Android 15/16.
