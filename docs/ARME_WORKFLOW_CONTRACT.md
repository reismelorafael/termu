# ARME Workflow Contract

Este documento define o contrato obrigatório para impedir código fingido gerado a partir de texto conceitual sem trilha técnica executável.

## 1) Fonte de verdade
- `Arme/manifest.json` é inventário obrigatório de todo arquivo de primeiro nível em `Arme/` e `Arme/Add/`.
- Toda alteração nesses diretórios deve atualizar o manifest antes de merge.
- O schema oficial é `Arme/manifest.schema.json`.
- Diretórios canônicos de produção: `Arme/spec/`, `Arme/include/`, `Arme/src/c/`, `Arme/src/asm/arm32/`, `Arme/src/asm/arm64/`, `Arme/tests/`, `Arme/bench/`, `Arme/reports/`.

## 2) Classificação obrigatória por item
Cada item precisa conter:
- `arquivo`
- `tipo`
- `status`
- `pode_compilar`
- `pode_extrair`
- `risco`
- `acao_recomendada`

## 3) Regras anti “código fingido”
- Texto conceitual (`.txt`, `.md`) não pode ser promovido implicitamente a artefato executável.
- Qualquer código novo derivado de texto conceitual exige:
  1. contrato técnico explícito no PR;
  2. teste/validação automatizada;
  3. entrada correspondente no manifest com `tipo=implementavel` ou `experimental`.
- Scripts/módulos classificados como `legado` ou `bloqueado` não podem entrar no pipeline oficial de release.

## 4) Gate de CI
- O script `scripts/validate_arme_manifest.sh` deve rodar em CI.
- `Arme/Add/` é staging: novos `.c/.S/.h` só entram com entrada explícita no manifesto e aprovação de promoção.
- O script `scripts/check_arme_add_manifest_gate.sh` bloqueia inclusão direta em staging sem classificação.
- O gate falha se:
  - houver arquivo de primeiro nível em `Arme/` ou `Arme/Add/` sem classificação;
  - existir item no manifest sem arquivo real;
  - o schema mínimo não for atendido;
  - `Arme/compilador_asm_legacy.sh` não estiver como `tipo=legado` e `pode_compilar=false`.

## 6) Promoção de módulos de staging para produção
- Promoção oficial deve usar `scripts/promote_arme_module.sh`.
- O script exige:
  1. classificação no manifesto (`tipo=implementavel|experimental` e `pode_compilar=true`);
  2. teste mínimo de equivalência C/ASM quando existir par com mesmo stem em `Arme/Add/`;
  3. registro da decisão de promoção em `Arme/reports/promotion-audit.log`.

## 5) Governança de mudança
- Pull requests que alterem `Arme/` ou `Arme/Add/` devem mostrar diff do `manifest.json`.
- Mudanças de `tipo` ou `status` exigem justificativa técnica de risco e impacto.
- Divergência entre documentação e manifest é bloqueadora de merge.
