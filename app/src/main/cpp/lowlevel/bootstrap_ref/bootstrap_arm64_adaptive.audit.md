# ARM64 Bootstrap Audit Contract (reference-only)

Status: `reference-only` (não compilável no pipeline ainda)
Escopo: `bootstrap_arm64_adaptive.s.txt`

## Contrato por função

| Função | Entrada | Saída | Registradores usados | Preservação esperada | Risco conhecido | Correção planejada |
|---|---|---|---|---|---|---|
| `_start` | stack inicial Linux/AArch64 (`argc`,`argv`,`envp`,`auxv`) | transição para init/repl | `x0-x3,x19-x30,sp` | preservar `x19-x29` durante subcalls | extração `auxv` e `envp` pode divergir por variação de layout | validar parser de stack com fixture e checks de offset |
| `hwcap_probe_arm64` | ponteiro `auxv` | flags HWCAP/HWCAP2 globais | `x0-x12` | não corromper `x19+` | conflito de uso scratch/syscall em caminhos mistos | padronizar convenção de scratch (`x9-x15`) e syscall (`x8`) |
| `dispatch_rewire_arm64` | flags de capacidade | tabela de dispatch ajustada | `x0-x11` | escrita somente em tabela dispatch | possibilidade de ponteiro errado por bitmask parcial | validar bitmask e endereços com teste de símbolos |
| `init_crc_table_arm64` | poly CRC32C | tabela CRC inicializada | `x0-x10,w0-w10` | sem dependência externa | encoding/manual opcodes podem divergir assembler | preferir instruções canônicas e teste cruzado com C |
| `toro_step_arm64` | estado T^7 Q16.16 | novo estado + checksum parcial | `x0-x18,v0-v7` | preservar registradores callee-saved | risco de overflow sem normalização | saturação Q16.16 + asserts de faixa |
| `repl_arm64` | estado runtime + arena | loop de comandos | `x0-x30` | preservar contrato ABI em chamadas | `execve/wait4` argv/args podem estar incorretos | corrigir montagem de argv e assinatura syscalls |

## Regras de preservação

- `x8` reservado para número de syscall em fronteira `svc #0`.
- `x19-x29` callee-saved: qualquer função chamada deve restaurar.
- `sp` alinhado em 16 bytes em todo call boundary.

## Backlog bloqueante antes de promover para `.S` compilável

1. Fechar contrato de registradores por função com teste automatizado.
2. Revisar caminhos `execve` e `wait4` contra ABI Linux AArch64.
3. Validar CRC32C contra implementação C de referência (vetores fixos).
4. Rodar montagem isolada (`clang --target=aarch64-linux-android`) em CI.
5. Só então mover para `bootstrap_src/bootstrap_arm64_adaptive.S`.
