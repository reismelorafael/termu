# Ponte Livro Vivo — Android, Termux e Execução Reprodutível

> Modo: ponte operacional entre `termux-app-rafacodephi` e o Livro Vivo RAFAELIA  
> Status inicial: `RESULTADO_COMPUTACIONAL` quando houver build/execução reproduzível  
> Regra: execução real precisa declarar aparelho, ABI, SDK, comando, saída e falha conhecida

## Parábola da chave móvel

O ferreiro construiu uma chave para uma porta que se movia.

O discípulo reclamou:

— Mestre, ontem abriu; hoje não abre.

O mestre respondeu:

— Então registra a porta, a dobradiça, o vento e a mão que girou a chave.

Em Android, até o vento muda o teste.

## Invariante

```text
Android sem root → shell local → comando → saída → artefato reproduzível
```

Forma compacta:

```math
Inv(Termux)=Dispositivo\rightarrow Ambiente\rightarrow Execução\rightarrow Resultado\rightarrow Relatório
```

## Risco principal

| Risco | Correção |
|---|---|
| build depende de estado local invisível | declarar ambiente e comandos |
| permissões Android quebram execução | documentar permissões e API alvo |
| phantom process killer interfere | registrar mitigação e foreground service |
| ABI/SDK não declarado | matriz por aparelho e arquitetura |
| resultado único parece release estável | marcar como `RESULTADO_COMPUTACIONAL` |

## Próximos passos

1. Criar `ANDROID_TERMUX_EXECUTION_MATRIX.md`.
2. Declarar device, Android API, ABI, CPU, RAM e storage.
3. Registrar comandos copiáveis.
4. Criar smoke test mínimo.
5. Separar app, bootstrap, shell, package bridge e backend real.

## Ficha Livro Vivo

```yaml
repo: rafaelmeloreisnovo/termux-app-rafacodephi
familia: Android/Termux
invariante: "Android sem root → shell local → execução reproduzível"
selo: RESULTADO_COMPUTACIONAL
risco: "ambiente local não documentado, permissões Android e build instável"
proximo_passo: "criar matriz Android/Termux com comandos e falhas conhecidas"
```

## Retroalimentar[3]

- **F_ok:** a ponte define o chão mínimo para execução Android/Termux.
- **F_gap:** falta transformar auditorias anteriores em matriz versionada.
- **F_next:** criar `ANDROID_TERMUX_EXECUTION_MATRIX.md` com aparelhos, ABIs, SDKs, comandos e resultados.
