# RAFCODEΦ Auditor — Implementation Roadmap

## Objetivo

Transformar o auditor RAFCODEΦ em uma ferramenta prática de engenharia de desempenho para Android/Termux, com medições locais, execução reproduzível e comparação histórica.

## Fase 1 — Inventário determinístico

Capturar informações estáveis do ambiente:

| Módulo | Fonte provável | Saída esperada |
|---|---|---|
| CPU | `/proc/cpuinfo` | ISA, núcleos, features, NEON |
| Android | APIs Java/Android | API level, target/min SDK, package id |
| Kernel | `uname`, `/proc/version` | versão, arquitetura, modo 32/64 bits |
| ABI | build config + runtime | ABI ativa, ABIs suportadas |
| Page size | native probe | 4096/16384 e alinhamento ELF |
| Bootstrap | hashes + contrato | integridade SHA256/BLAKE3 |

## Fase 2 — Benchmarks mínimos

Criar uma suíte leve e segura para aparelhos limitados.

| Família | Teste | Métrica |
|---|---|---|
| CPU | inteiro simples | ops/s |
| NEON | vetor/cópia | MB/s |
| CRC/SHA | checksum | MB/s + validação |
| Memória | memcpy/read/write | MB/s + variação |
| Storage | read/write seq. | MB/s |
| Storage | small random I/O | IOPS |
| Processos | spawn shell | ms |
| Git | status/log/hash | tempo |
| Clang | compile tiny C | tempo + RAM |
| BusyBox | coreutils loop | tempo |
| proot | start/exec baseline | tempo |

## Fase 3 — Estatística

Executar cada teste em múltiplas rodadas.

Mínimo recomendado:

```text
runs = 7
warmup = 2
reported = median + p90 + stddev + min + max
```

Campos por métrica:

```json
{
  "metric": "storage.seq_read",
  "unit": "MB/s",
  "runs": [52.1, 54.0, 55.4, 55.1, 54.8],
  "median": 54.8,
  "p90": 55.4,
  "stddev": 1.1,
  "checksum": "...",
  "status": "stable"
}
```

## Fase 4 — Temperatura e frequência

Adicionar sondas quando disponíveis:

- `/sys/class/thermal/*/temp`;
- `/sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq`;
- governor;
- online/offline cores;
- bateria/energia quando acessível.

Essas métricas devem ser opcionais, pois variam muito por fabricante e permissões.

## Fase 5 — Relatório operacional

Gerar três saídas:

1. `auditor-report.md` — leitura humana;
2. `auditor-report.json` — dados consumíveis por CI;
3. `auditor-history.jsonl` — histórico incremental.

O relatório humano deve conter:

- resumo executivo;
- coerência/evidência/utilidade;
- tabela de invariantes;
- tabela de benchmarks;
- lacunas detectadas;
- regressões;
- recomendações com nível de evidência.

## Fase 6 — Regressão histórica

Comparar execução atual com base anterior.

Classificação sugerida:

| Variação | Estado |
|---:|---|
| até ±3% | estável |
| 3% a 10% | atenção |
| >10% | regressão ou ganho relevante |

Nenhuma regressão deve ser declarada sem observar variância e contexto térmico.

## Fase 7 — CI/CD

Integrar ao GitHub Actions:

- rodar auditor básico no build beta;
- anexar JSON/Markdown como artefato;
- publicar summary elegante;
- não bloquear release por métrica experimental;
- bloquear somente por falha de integridade/contrato.

## Fronteira de segurança operacional

O auditor não deve:

- exigir root;
- alterar governor do usuário;
- forçar carga térmica longa sem confirmação;
- escrever dados grandes em armazenamento sem limite;
- declarar ganho sem repetição estatística;
- quebrar aparelhos ARMv7 limitados.

## Próximo incremento recomendado

Criar `scripts/rafcodephi_auditor.sh` com módulos independentes:

```text
inventory
cpu
memory
storage
git
clang
busybox
proot
report
```

Cada módulo deve poder rodar isoladamente:

```bash
./scripts/rafcodephi_auditor.sh inventory
./scripts/rafcodephi_auditor.sh storage
./scripts/rafcodephi_auditor.sh report
```

## Resultado esperado

O RAFCODEΦ passa de relatório estático para laboratório operacional:

```text
medir → comparar → inferir → otimizar → validar → registrar → repetir
```
