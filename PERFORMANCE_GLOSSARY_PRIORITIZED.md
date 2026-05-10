# Glossário de Performance (Prioridade Prática para Android/NDK)

## Mata performance (hot path)
- Alocação dinâmica excessiva (`malloc/free`, fragmentação, heap lock).
- Cache/TLB miss, pointer chasing, baixa localidade de dados.
- Branch misprediction em laços críticos.
- JNI/FFI por elemento (chamadas em granularidade errada).
- Lock contention, false sharing, context switch em excesso.
- Cópias redundantes (sem zero-copy/batching).
- Syscalls em alta frequência sem agregação.

## Pesa médio (depende de escala/uso)
- Virtual dispatch e indireções em caminho quente.
- Reflection e exception como fluxo comum.
- Binary bloat que piora i-cache/load time.
- Gradle/configuração pesada e dependency overhead no ciclo de build.
- Emulação (QEMU/TCG) quando usada em validação frequente.

## Só importa em escala ou cenários específicos
- Loop unrolling manual fora de kernels críticos.
- Prefetch manual sem perfil concreto.
- Ajustes finos de alinhamento/padding em estruturas frias.
- Micro-otimizações de cold path.

---

## Mapa C/ASM/NDK (ARM32/ARM64)

### Onde aparece direto no código
- **C/JNI**: custo de fronteira Java ↔ nativo; reduzir quantidade de chamadas.
- **C nativo**: layout de dados (AoS vs SoA), alinhamento, localidade e alocação.
- **ASM/NEON**: kernels vetoriais, cópia, checksum/hash, processamento de buffer.
- **Build NDK**: ABI split (`armeabi-v7a`, `arm64-v8a`), flags por ABI e strip de símbolos.

### Contratos que não podem divergir
- ABI declarada no Gradle/workflow/artifact.
- Mesma matriz de ABIs no build local e CI.
- Assinatura separada por trilha (debug/teste vs release oficial).

---

## Checklist estrutural de otimização

1. **Hot path sem alocação**: evitar `malloc/free` por iteração.
2. **Batch + zero-copy**: reduzir cópias e syscalls curtas.
3. **JNI coarse-grained**: chamadas nativas por lote, não por item.
4. **Localidade**: dados contíguos; reduzir pointer chasing.
5. **Branches previsíveis**: remover desvios imprevisíveis do loop crítico.
6. **Sincronização mínima**: reduzir lock contention, usar atomics com critério.
7. **NEON quando aplicável**: fallback C puro validado.
8. **ARM32 + ARM64 sempre**: build, teste e artefato para ambos.
9. **Release assinado preservado**: não converter fluxo oficial em unsigned.
10. **Medição obrigatória**: latency p95/p99 + throughput antes/depois.

---

## Regra de decisão
- **Fricção inevitável**: segurança/correção/contrato de ABI.
- **Fricção removível**: camada redundante, cópia desnecessária, branch ruim.
- **Fricção aceitável fora do hot path**: legibilidade/diagnóstico em rotas frias.
