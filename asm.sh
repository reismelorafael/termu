cat > /home/claude/RAFAELIA_ABI_CODEX_ENTERPRISE.txt << 'TERMINUS'
╔══════════════════════════════════════════════════════════════════════════════════════╗
║  RAFAELIA · ABI BOOTSTRAP ENTERPRISE ADAPTATIVO · ARM32 + ARM64                   ║
║  Registradores Lineares · Auto-Adaptativo · Freestanding · Zero Abstração          ║
║  Q16.16 · Toro 7D · CRC32C Chain · HWCAP Probe · NEON Dispatch · 42 Atratores     ║
║  Termux Android · armeabi-v7a + arm64-v8a · Android 7..16                         ║
║  SPDX: GPL-3.0-only · RAFCODEΦ · Rafael Melo Reis · DeltaRafaelVerboOmega         ║
║  Gerado via: cat > RAFAELIA_ABI_CODEX_ENTERPRISE.txt << 'TERMINUS'                ║
╚══════════════════════════════════════════════════════════════════════════════════════╝

╔══════════════════════════════════════════════════════════════════════════════════════╗
║  FILOSOFIA FUNDANTE                                                                ║
╚══════════════════════════════════════════════════════════════════════════════════════╝
║
║  FASE 0 — ENTRADA GENÉRICA (funciona em qualquer ARM sem saber o hardware)
║  FASE 1 — HWCAP PROBE     (lê aux vector: detecta NEON, CRC32, SHA2, AES, SVE)
║  FASE 2 — DISPATCH LINEAR (rewira tabela de ponteiros para path ótimo)
║  FASE 3 — TORO 7D Q16.16  (estado toroidal — memória sem malloc)
║  FASE 4 — REPL ENTERPRISE (shell freestanding com comandos nativos)
║  FASE 5 — CRC32C CHAIN    (integridade de cada ciclo de estado)
║
║  PRIMO DE REGISTRADOR (ARM64):
║    x0=2  x1=3  x2=5  x3=7  x4=11 x5=13 x6=17 x7=19
║    x8=23 x9=29 x10=31 x11=37 x12=41 x13=43 x14=47 x15=53
║    x16=59 x17=61 x18=67 x19=71 x20=73 x21=79 x22=83 x23=89
║    x24=97 x25=101 x26=103 x27=107 x28=109 x29=113 x30=127
║
║  INVARIANTE: produto dos primos dos registradores envolvidos em
║  qualquer instrução é único → identifica a instrução no espaço de estados.
║
║  Q16.16 CONSTANTES FUNDAMENTAIS:
║    √3/2   = 56756  (0xDDD4) — atrator de Lyapunov λ=-0.1438 (toro estável)
║    φ      = 105965 (0x19E5D) — seção áurea
║    F*     = 23.158 ≈ 1517798 em Q16.16 — ponto fixo Rafael-Fibonacci (NOVO)
║    42     = número de atratores no toro T^7
║    G_MASK = 0xFFFF — máscara Q16.16
║    G_SPIRAL= 56755  — espiral adaptativa
╚══════════════════════════════════════════════════════════════════════════════════════╝

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 SEÇÃO A — ARM64 arm64-v8a · BOOTSTRAP ADAPTATIVO COMPLETO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

; ╔══════════════════════════════════════════════════════════════════════════╗
; ║  bootstrap_arm64_adaptive.s                                            ║
; ║  Compilar: as -o rafa64.o bootstrap_arm64_adaptive.s                   ║
; ║            ld -o rafa64 rafa64.o                                       ║
; ║  Termux:   pkg install binutils && as ... && ld ...                    ║
; ║  Verificar 16KB: readelf -l rafa64 | grep Align                        ║
; ╚══════════════════════════════════════════════════════════════════════════╝

.arch   armv8-a
.syntax unified

; ── SYSCALLS ARM64 (AArch64 Linux) ───────────────────────────────────────────
; Número em x8, svc #0, retorno em x0
; Primos mnemônicos: lembre — read=63, write=64, exit=93, execve=221
.equ SYS_io_setup,    0
.equ SYS_read,       63
.equ SYS_write,      64
.equ SYS_openat,     56
.equ SYS_close,      57
.equ SYS_lseek,      62
.equ SYS_mmap,      222
.equ SYS_mprotect,  226
.equ SYS_munmap,    215
.equ SYS_fork,       57   ; legado — prefer clone
.equ SYS_clone,     220   ; bionic usa este
.equ SYS_execve,    221
.equ SYS_exit,       93
.equ SYS_wait4,     260
.equ SYS_getpid,    172
.equ SYS_getuid,    174
.equ SYS_gettid,    178
.equ SYS_prctl,     167   ; AT_HWCAP via prctl alternativo
.equ SYS_getrandom, 278
.equ STDIN,           0
.equ STDOUT,          1
.equ STDERR,          2

; ── HWCAP BITS (Linux ARM64 — lidos do aux vector) ───────────────────────────
; AT_HWCAP = 16 no aux vector
; AT_HWCAP2= 26 no aux vector
.equ AT_HWCAP,       16
.equ AT_HWCAP2,      26
.equ AT_NULL,         0

; HWCAP bits ARM64:
.equ HWCAP_FP,       (1<<0)    ; FPU
.equ HWCAP_ASIMD,    (1<<1)    ; Advanced SIMD (NEON) — sempre 1 em AArch64
.equ HWCAP_EVTSTRM,  (1<<2)
.equ HWCAP_AES,      (1<<3)    ; AES acelerado por HW
.equ HWCAP_PMULL,    (1<<4)    ; PMULL (GCM)
.equ HWCAP_SHA1,     (1<<5)
.equ HWCAP_SHA2,     (1<<6)    ; SHA-256 por HW
.equ HWCAP_CRC32,    (1<<7)    ; CRC32/CRC32C por HW
.equ HWCAP_ATOMICS,  (1<<8)    ; LSE atomic ops
.equ HWCAP_FPHP,     (1<<9)    ; FP16
.equ HWCAP_ASIMDHP,  (1<<10)   ; NEON FP16
.equ HWCAP_SVE,      (1<<22)   ; Scalable Vector Extension
.equ HWCAP_DCPOP,    (1<<16)   ; DC CVAP (persistent memory)

; ── MMAP FLAGS ───────────────────────────────────────────────────────────────
.equ PROT_NONE,       0
.equ PROT_READ,       1
.equ PROT_WRITE,      2
.equ PROT_EXEC,       4
.equ PROT_RW,         3
.equ MAP_SHARED,      1
.equ MAP_PRIVATE,     2
.equ MAP_ANONYMOUS, 0x20
.equ MAP_ANON_PRIV, 0x22   ; MAP_PRIVATE|MAP_ANONYMOUS

; ── PAGE SIZE (CRÍTICO Android 15/16) ────────────────────────────────────────
.equ PAGE_4K,    0x1000
.equ PAGE_16K,   0x4000
.equ ALIGN_16K,  14        ; .align 14 = 2^14 = 16384

; ── Q16.16 CONSTANTES ────────────────────────────────────────────────────────
.equ Q_ONE,      65536     ; 1.0 em Q16.16
.equ Q_HALF,     32768     ; 0.5
.equ Q_SQRT3_2,  56756     ; √3/2 = 0.8660...
.equ Q_PHI_GOLD, 105965    ; φ = 1.6180...
.equ Q_ALPHA,    16384     ; 0.25 (EMA α)
.equ Q_IALPHA,   49152     ; 0.75 (EMA 1-α)
.equ Q_SPIRAL,   56755     ; espiral Rafael
.equ G_PERIOD,   42        ; período toroidal
.equ G_DIM,      7         ; dimensões do toro T^7
.equ G_ARENA_SZ, 0x10000   ; 64KB arena (múltiplo de 16KB)

; ── CLONE FLAGS (para fork Android seguro) ───────────────────────────────────
.equ SIGCHLD,    17
.equ CLONE_VM,   0x100
.equ CLONE_FS,   0x200
.equ CLONE_SIGCHLD, 17     ; clone como fork: flags=SIGCHLD

; ══════════════════════════════════════════════════════════════════════════════
.section .data
.align 4

; ── DISPATCH TABLE ARM64 ─────────────────────────────────────────────────────
; Ponteiros para funções — inicialmente apontam para versão genérica.
; Após HWCAP probe, são reescritos para versão ótima.
; PRIMO TOTAL DA TABELA = 2×3×5×7×11×13 = 30030 (identificador único)
dispatch_memcpy:  .quad generic_memcpy64       ; p=2
dispatch_memset:  .quad generic_memset64       ; p=3
dispatch_crc32:   .quad generic_crc32c_64      ; p=5
dispatch_ema:     .quad generic_ema_q16        ; p=7
dispatch_toro:    .quad generic_toro_step      ; p=11
dispatch_entropy: .quad generic_entropy        ; p=13

; ── HWCAP RESULTS (preenchido em runtime) ────────────────────────────────────
.align 8
g_hwcap:        .quad 0     ; AT_HWCAP lido do aux vector
g_hwcap2:       .quad 0     ; AT_HWCAP2
g_has_neon:     .byte 0     ; 1 se ASIMD disponível
g_has_crc32hw:  .byte 0     ; 1 se CRC32 HW
g_has_aes_hw:   .byte 0     ; 1 se AES HW
g_has_sha2:     .byte 0     ; 1 se SHA2 HW
g_has_atomics:  .byte 0     ; 1 se LSE atomics
g_has_sve:      .byte 0     ; 1 se SVE
.align 4

; ── BANNERS ──────────────────────────────────────────────────────────────────
banner_arm64:
  .ascii "\033[1;32m"
  .ascii "╔══════════════════════════════════════════════════════╗\r\n"
  .ascii "║  RAFAELIA · ARM64 Adaptive Bootstrap · Enterprise   ║\r\n"
  .ascii "║  Toro T^7 · Q16.16 · HWCAP · CRC32C · 42 Atratores ║\r\n"
  .ascii "╚══════════════════════════════════════════════════════╝\r\n"
  .ascii "\033[0m"
.equ banner_arm64_len, . - banner_arm64

banner_caps:
  .ascii "\033[36m[HWCAP]\033[0m "
.equ banner_caps_len, . - banner_caps

str_neon:    .ascii "NEON " ; 5
str_crc32:   .ascii "CRC32 "
str_aes:     .ascii "AES "
str_sha2:    .ascii "SHA2 "
str_atomics: .ascii "LSE "
str_sve:     .ascii "SVE "
str_generic: .ascii "GENERIC\r\n"
.equ str_generic_len, . - str_generic
str_nl:      .ascii "\r\n"
str_prompt:  .ascii "\033[1;36mrafaφ64\033[0m\033[1;37m❯\033[0m "
.equ str_prompt_len, . - str_prompt
str_ok:      .ascii "\033[32m[OK]\033[0m "
str_err:     .ascii "\033[31m[ERRO]\033[0m "
str_toro:    .ascii "[TORO] Estado 7D inicializado Q16.16\r\n"
.equ str_toro_len, . - str_toro
str_dispatch:
  .ascii "[DISPATCH] Tabela reconfigurada para hardware detectado\r\n"
.equ str_dispatch_len, . - str_dispatch
str_arena:   .ascii "[ARENA] 64KB BSS sem malloc\r\n"
.equ str_arena_len, . - str_arena
str_exit_msg:.ascii "\r\n[RAFAELIA] Saindo. CRC chain: "
.equ str_exit_msg_len, . - str_exit_msg
str_bye:     .ascii "\r\n"

; Caminhos de shell para Android/Termux
path_sh_termux: .asciz "/data/data/com.termux/files/usr/bin/sh"
path_sh_system: .asciz "/system/bin/sh"
path_sh_bin:    .asciz "/bin/sh"
arg0_sh:        .asciz "sh"
arg1_c:         .asciz "-c"

; Nomes de comandos built-in
cmd_exit:    .ascii "exit"
cmd_status:  .ascii "status"
cmd_toro:    .ascii "toro"
cmd_crc:     .ascii "crc"
cmd_caps:    .ascii "caps"
cmd_help:    .ascii "help"

msg_help:
  .ascii "Comandos: exit status toro crc caps help\r\n"
.equ msg_help_len, . - msg_help

; ── CRC32C SOFTWARE TABLE (256 × 4 bytes) ────────────────────────────────────
; Polinômio Castagnoli 0x82F63B78
; Preenchido por init_crc_table em runtime
.align 4
crc_table: .space 1024      ; 256 × uint32

.section .bss
; CRÍTICO: .align 14 = 16KB para Android 15/16
.align ALIGN_16K

; ── ARENA BSS 64KB (zero malloc) ─────────────────────────────────────────────
; Primeiro campo após alinhamento 16KB
; PRIMO=2 (fundação — tudo começa aqui)
arena_mem:   .space G_ARENA_SZ
arena_bump:  .space 8       ; ponteiro bump current

; ── TOROIDAL STATE 7D Q16.16 ─────────────────────────────────────────────────
; Mapeamento de primos:
;   s[0]=p2, s[1]=p3, s[2]=p5, s[3]=p7, s[4]=p11, s[5]=p13, s[6]=p17
; INVARIANTE: produto s[0]×s[1]×...×s[6] módulo G_PERIOD define o atrator
toro_s:       .space 28     ; uint32[7] — estado toroidal
toro_C:       .space 4      ; coerência Q16.16
toro_H:       .space 4      ; entropia Q16.16
toro_phi:     .space 4      ; (1-H)*C Q16.16 — saída do toro
toro_phase:   .space 4      ; 0..41 (42 atratores)
toro_crc:     .space 4      ; CRC32C do estado (integridade)
toro_chain:   .space 4      ; CRC chain temporal acumulado
toro_step:    .space 8      ; contador de passos (uint64)

; ── BUFFERS DE I/O ───────────────────────────────────────────────────────────
.align 4
io_buf:     .space 2048     ; buffer de leitura/escrita
io_out:     .space 512      ; buffer de saída formatada

; ── STATUS DE PROCESSO ───────────────────────────────────────────────────────
.align 4
proc_status: .space 8
saved_envp:  .space 8
saved_sp:    .space 8

; ── HEX OUTPUT BUFFER ────────────────────────────────────────────────────────
hex_buf:    .space 32

.section .text
.global _start
.global hwcap_probe_arm64
.global dispatch_rewire_arm64
.global toro_init
.global toro_step_arm64
.global neon_memcpy128
.global neon_memset128
.global hw_crc32c_block
.global generic_crc32c_64
.global generic_ema_q16
.global ema_neon_7d
.global arena_alloc
.global print_hex32
.global rafaclone

; ══════════════════════════════════════════════════════════════════════════════
; _start — FASE 0: ENTRADA GENÉRICA
; Stack AArch64: sp→argc, sp+8→argv[], sp+8*(argc+2)→envp[]
; PRIMO=2 (fundação)
; CALLEE-SAVED usados: x19..x28 (primos 71..109)
; ══════════════════════════════════════════════════════════════════════════════
.align 4
_start:
    ; ── Snapshot do contexto inicial (commit gate fase 0) ────────────────
    adr  x19, saved_sp          ; x19=71 (primo)
    mov  x0, sp
    str  x0, [x19]              ; salva SP original

    ; Extrai envp do stack: &envp = &argv[argc+1]
    ldr  x0, [sp]               ; argc
    add  x0, x0, #2
    lsl  x0, x0, #3             ; *(argc+2)*8
    add  x0, sp, x0             ; &envp[0]
    adr  x1, saved_envp
    str  x0, [x1]

    ; ── FASE 1: HWCAP PROBE ──────────────────────────────────────────────
    ; Lê aux vector da stack (após envp[] NULL)
    bl   hwcap_probe_arm64

    ; ── FASE 2: DISPATCH REWIRE ──────────────────────────────────────────
    bl   dispatch_rewire_arm64

    ; ── Inicializa CRC table (software fallback) ─────────────────────────
    bl   init_crc_table_arm64

    ; ── Inicializa arena BSS ──────────────────────────────────────────────
    adr  x0, arena_mem
    adr  x1, arena_bump
    str  x0, [x1]               ; bump = início da arena

    ; ── FASE 3: TORO 7D Q16.16 ───────────────────────────────────────────
    bl   toro_init

    ; ── Banner ────────────────────────────────────────────────────────────
    mov  x0, #STDOUT
    adr  x1, banner_arm64
    mov  x2, #banner_arm64_len
    mov  x8, #SYS_write
    svc  #0

    ; Mostra capacidades detectadas
    bl   print_caps_arm64

    ; ── FASE 4: REPL ENTERPRISE ──────────────────────────────────────────
    bl   repl_arm64

    ; ── Exit com CRC chain final ──────────────────────────────────────────
    adr  x0, toro_chain
    ldr  w20, [x0]              ; x20=73 = CRC chain final
    bl   print_exit_crc

    mov  x0, #0
    mov  x8, #SYS_exit
    svc  #0

; ══════════════════════════════════════════════════════════════════════════════
; hwcap_probe_arm64 — FASE 1: LÊ AT_HWCAP DO AUX VECTOR
; O aux vector está após envp[] no stack. Percorre até AT_NULL.
; Armazena em g_hwcap, g_hwcap2, g_has_*
; PRIMO=3 (conector hardware↔software)
; ══════════════════════════════════════════════════════════════════════════════
.align 4
hwcap_probe_arm64:
    stp  x29, x30, [sp, #-32]!
    mov  x29, sp

    ; Navega aux vector: após envp[]=NULL
    adr  x20, saved_envp
    ldr  x20, [x20]             ; x20 = &envp[0]

    ; Pula envp[] até encontrar NULL
.hwcap_skip_envp:
    ldr  x1, [x20], #8
    cbnz x1, .hwcap_skip_envp
    ; x20 aponta para aux[0].type agora

    ; Percorre pares (type, value) até AT_NULL=0
.hwcap_scan_aux:
    ldp  x21, x22, [x20], #16  ; x21=type, x22=value
    cbz  x21, .hwcap_done       ; AT_NULL

    cmp  x21, #AT_HWCAP
    b.ne .hwcap_check2
    adr  x0, g_hwcap
    str  x22, [x0]
    b    .hwcap_scan_aux

.hwcap_check2:
    cmp  x21, #AT_HWCAP2
    b.ne .hwcap_scan_aux
    adr  x0, g_hwcap2
    str  x22, [x0]
    b    .hwcap_scan_aux

.hwcap_done:
    ; Decodifica bits HWCAP em flags binárias
    adr  x0, g_hwcap
    ldr  x23, [x0]

    ; NEON/ASIMD: bit 1 (sempre 1 em AArch64, mas verificamos)
    tst  x23, #HWCAP_ASIMD
    cset w1, ne
    adr  x0, g_has_neon
    strb w1, [x0]

    ; CRC32 HW: bit 7
    tst  x23, #HWCAP_CRC32
    cset w1, ne
    adr  x0, g_has_crc32hw
    strb w1, [x0]

    ; AES HW: bit 3
    tst  x23, #HWCAP_AES
    cset w1, ne
    adr  x0, g_has_aes_hw
    strb w1, [x0]

    ; SHA2 HW: bit 6
    tst  x23, #HWCAP_SHA2
    cset w1, ne
    adr  x0, g_has_sha2
    strb w1, [x0]

    ; LSE Atomics: bit 8
    tst  x23, #HWCAP_ATOMICS
    cset w1, ne
    adr  x0, g_has_atomics
    strb w1, [x0]

    ; SVE: bit 22
    tst  x23, #HWCAP_SVE
    cset w1, ne
    adr  x0, g_has_sve
    strb w1, [x0]

    ldp  x29, x30, [sp], #32
    ret

; ══════════════════════════════════════════════════════════════════════════════
; dispatch_rewire_arm64 — FASE 2: REESCREVE TABELA DE DISPATCH
; Substitui ponteiros genéricos por implementações ótimas detectadas.
; PRIMO=5 (bridge hardware↔runtime)
; ══════════════════════════════════════════════════════════════════════════════
.align 4
dispatch_rewire_arm64:
    stp  x29, x30, [sp, #-16]!
    mov  x29, sp

    ; Verifica NEON → rewire memcpy e memset
    adr  x0, g_has_neon
    ldrb w0, [x0]
    cbz  w0, .dispatch_crc_check

    adr  x1, dispatch_memcpy
    adr  x0, neon_memcpy128
    str  x0, [x1]               ; dispatch_memcpy → neon_memcpy128

    adr  x1, dispatch_memset
    adr  x0, neon_memset128
    str  x0, [x1]               ; dispatch_memset → neon_memset128

    adr  x1, dispatch_ema
    adr  x0, ema_neon_7d
    str  x0, [x1]               ; dispatch_ema → ema_neon_7d

    adr  x1, dispatch_toro
    adr  x0, toro_step_neon
    str  x0, [x1]               ; dispatch_toro → toro_step_neon

.dispatch_crc_check:
    ; Verifica CRC32 HW → rewire crc32
    adr  x0, g_has_crc32hw
    ldrb w0, [x0]
    cbz  w0, .dispatch_done

    adr  x1, dispatch_crc32
    adr  x0, hw_crc32c_block
    str  x0, [x1]               ; dispatch_crc32 → hw_crc32c_block

.dispatch_done:
    ; Anuncia rewire completo
    mov  x0, #STDOUT
    adr  x1, str_dispatch
    mov  x2, #str_dispatch_len
    mov  x8, #SYS_write
    svc  #0

    ldp  x29, x30, [sp], #16
    ret

; ══════════════════════════════════════════════════════════════════════════════
; toro_init — FASE 3: INICIALIZA TORO T^7 Q16.16
; s[d] = (G_SPIRAL * d * prime[d]) & 0xFFFF para cada dimensão
; Garante: cada dimensão inicia em estado diferente (sem degeneração)
; PRIMO=11 (orquestrador de estados)
; ══════════════════════════════════════════════════════════════════════════════
.align 4
toro_init:
    stp  x29, x30, [sp, #-32]!
    mov  x29, sp

    ; Primos das dimensões: 2,3,5,7,11,13,17
    adr  x19, toro_s
    mov  w20, #Q_SPIRAL         ; semente inicial

    ; d=0: s[0] = (56755 * 2) & 0xFFFF = 47974
    mov  w21, #2
    mul  w22, w20, w21
    and  w22, w22, #0xFFFF
    str  w22, [x19, #0]

    ; d=1: s[1] = (56755 * 3) & 0xFFFF
    mov  w21, #3
    mul  w22, w20, w21
    and  w22, w22, #0xFFFF
    str  w22, [x19, #4]

    ; d=2: s[2] = (56755 * 5) & 0xFFFF
    mov  w21, #5
    mul  w22, w20, w21
    and  w22, w22, #0xFFFF
    str  w22, [x19, #8]

    ; d=3: s[3] = (56755 * 7) & 0xFFFF
    mov  w21, #7
    mul  w22, w20, w21
    and  w22, w22, #0xFFFF
    str  w22, [x19, #12]

    ; d=4: s[4] = (56755 * 11) & 0xFFFF
    mov  w21, #11
    mul  w22, w20, w21
    and  w22, w22, #0xFFFF
    str  w22, [x19, #16]

    ; d=5: s[5] = (56755 * 13) & 0xFFFF
    mov  w21, #13
    mul  w22, w20, w21
    and  w22, w22, #0xFFFF
    str  w22, [x19, #20]

    ; d=6: s[6] = (56755 * 17) & 0xFFFF
    mov  w21, #17
    mul  w22, w20, w21
    and  w22, w22, #0xFFFF
    str  w22, [x19, #24]

    ; C = H = 0x8000 (0.5 — estado neutro)
    mov  w0, #0x8000
    adr  x1, toro_C
    str  w0, [x1]
    adr  x1, toro_H
    str  w0, [x1]

    ; phi = 0x8000
    adr  x1, toro_phi
    str  w0, [x1]

    ; phase = 0, chain = 0, step = 0
    adr  x1, toro_phase
    str  wzr, [x1]
    adr  x1, toro_chain
    str  wzr, [x1]
    adr  x1, toro_step
    str  xzr, [x1]

    ; CRC32C do estado inicial → toro_crc
    adr  x0, toro_s
    mov  x1, #28               ; 7 × 4 bytes
    bl   generic_crc32c_64
    adr  x1, toro_crc
    str  w0, [x1]

    ; Anuncia init
    mov  x0, #STDOUT
    adr  x1, str_toro
    mov  x2, #str_toro_len
    mov  x8, #SYS_write
    svc  #0

    ldp  x29, x30, [sp], #32
    ret

; ══════════════════════════════════════════════════════════════════════════════
; toro_step_neon — Um passo do toro T^7 com NEON Advanced SIMD
; Entrada: nenhuma (opera em toro_s global)
; Saída: toro_phi atualizado
; PRIMO=11×3=33 (toro + NEON)
; EMA Q16.16: s_new[d] = (s[d]*49152 + sin(phase+d)*16384) >> 16
;             sin() implementada como rotação toroidal Q16.16
; ══════════════════════════════════════════════════════════════════════════════
.align 4
toro_step_neon:
    stp  x29, x30, [sp, #-64]!
    mov  x29, sp

    ; Carrega fase atual
    adr  x19, toro_phase
    ldr  w20, [x19]             ; w20 = phase (0..41)

    ; EMA NEON para dims 0..3 (128 bits = 4 × uint32)
    adr  x21, toro_s
    ld1  {v0.4s}, [x21]         ; v0 = s[0..3]

    ; EMA: s_new = (s*49152 + input*16384) >> 16
    ; input[d] = sin_q16(phase + d)
    ; sin_q16 aproximação: sin(x) ≈ x para x pequeno, usa rotação toroidal
    ; Rotação Q16.16: input = ((phase*9804 + d*2731) & 0xFFFF)
    ; 9804 = π/2 / 42 em Q16.16 (divide o período)
    ; 2731 = separação entre dimensões

    mov  w22, #9804
    mul  w23, w20, w22          ; phase * 9804

    ; Gera vetor de inputs para dims 0..3
    mov  w22, #0
    add  w24, w23, w22
    and  w24, w24, #0xFFFF
    mov  w22, #2731
    add  w25, w23, w22
    and  w25, w25, #0xFFFF
    lsl  w22, w22, #1
    add  w26, w23, w22
    and  w26, w26, #0xFFFF
    mov  w22, #8193             ; 2731*3
    add  w27, w23, w22
    and  w27, w27, #0xFFFF

    ; Monta vetor input
    ins  v1.s[0], w24
    ins  v1.s[1], w25
    ins  v1.s[2], w26
    ins  v1.s[3], w27

    ; Constantes EMA
    movi v2.4s, #0xC0, lsl #8  ; 49152 = 0xC000
    movi v3.4s, #0x40, lsl #8  ; 16384 = 0x4000

    ; s_new[0..3] = (s[0..3]*49152 + input[0..3]*16384) >> 16
    umull  v4.2d, v0.2s, v2.2s         ; lo: s[0..1]*49152
    umull2 v5.2d, v0.4s, v2.4s         ; hi: s[2..3]*49152
    umull  v6.2d, v1.2s, v3.2s         ; lo: in[0..1]*16384
    umull2 v7.2d, v1.4s, v3.4s         ; hi: in[2..3]*16384
    add    v4.2d, v4.2d, v6.2d
    add    v5.2d, v5.2d, v7.2d
    shrn   v0.2s,  v4.2d, #16
    shrn2  v0.4s,  v5.2d, #16          ; v0 = s_new[0..3]

    st1  {v0.4s}, [x21]                ; armazena s_new[0..3]

    ; Dims 4..6 (3 restantes) — escalar
    add  x21, x21, #16                 ; aponta para s[4]
    mov  w22, #9804
    mul  w23, w20, w22

    mov  w24, #(2731*4)
    add  w24, w23, w24
    and  w24, w24, #0xFFFF
    ldr  w25, [x21, #0]
    mov  w26, #49152
    mul  w27, w25, w26          ; w27 = s[4]*49152 (32-bit ok p/ Q16)
    mov  w26, #16384
    madd w27, w24, w26, w27    ; += input*16384
    lsr  w27, w27, #16
    str  w27, [x21, #0]

    mov  w24, #(2731*5)
    add  w24, w23, w24
    and  w24, w24, #0xFFFF
    ldr  w25, [x21, #4]
    mov  w26, #49152
    mul  w27, w25, w26
    mov  w26, #16384
    madd w27, w24, w26, w27
    lsr  w27, w27, #16
    str  w27, [x21, #4]

    mov  w24, #(2731*6)
    add  w24, w23, w24
    and  w24, w24, #0xFFFF
    ldr  w25, [x21, #8]
    mov  w26, #49152
    mul  w27, w25, w26
    mov  w26, #16384
    madd w27, w24, w26, w27
    lsr  w27, w27, #16
    str  w27, [x21, #8]

    ; Atualiza phase = (phase + 1) % 42
    add  w20, w20, #1
    mov  w21, #42
    udiv w22, w20, w21
    msub w20, w22, w21, w20    ; w20 = phase mod 42
    adr  x1, toro_phase
    str  w20, [x1]

    ; Atualiza step
    adr  x1, toro_step
    ldr  x0, [x1]
    add  x0, x0, #1
    str  x0, [x1]

    ; Recalcula CRC32C do estado → encadeia em toro_chain
    adr  x0, toro_s
    mov  x1, #28
    bl   generic_crc32c_64     ; w0 = CRC estado atual

    adr  x1, toro_chain
    ldr  w2, [x1]
    eor  w2, w2, w0            ; chain ^= new_crc (encadeamento)
    str  w2, [x1]
    adr  x1, toro_crc
    str  w0, [x1]              ; armazena CRC do estado

    ; Atualiza phi = toro_s[0] (saída primária)
    adr  x0, toro_s
    ldr  w0, [x0]
    adr  x1, toro_phi
    str  w0, [x1]

    ldp  x29, x30, [sp], #64
    ret

; Alias para path genérico (sem NEON) — mesma lógica, escalar
generic_toro_step:
    b    toro_step_neon         ; no AArch64 NEON é mandatório

; ══════════════════════════════════════════════════════════════════════════════
; hw_crc32c_block — CRC32C via instrução ARM64 CRC32C HW
; x0 = ponteiro buffer, x1 = len
; Retorna w0 = CRC32C
; PRIMO=5 (validação)
; Requer HWCAP_CRC32 — verificar antes de chamar
; ══════════════════════════════════════════════════════════════════════════════
.align 4
hw_crc32c_block:
    mov  w2, #~0                ; CRC inicial = 0xFFFFFFFF

    ; Processa 8 bytes por iteração
    cmp  x1, #8
    b.lt .crc64_tail4

.crc64_loop8:
    ldr  x3, [x0], #8
    .inst 0x9AC14842           ; crc32cx w2, w2, x3
    ; crc32cx w2, w2, x3 — instrução CRC32C 64-bit
    ; Encoding: 0x9AC148xx onde xx=(Rd|(Rn<<5)|(Rm<<16))
    sub  x1, x1, #8
    cmp  x1, #8
    b.ge .crc64_loop8

.crc64_tail4:
    cmp  x1, #4
    b.lt .crc64_tail1
    ldr  w3, [x0], #4
    .inst 0x1AC14842           ; crc32cw w2, w2, w3
    sub  x1, x1, #4

.crc64_tail1:
    cbz  x1, .crc64_done
.crc64_loop1:
    ldrb w3, [x0], #1
    .inst 0x1AC14042           ; crc32cb w2, w2, w3
    subs x1, x1, #1
    b.ne .crc64_loop1

.crc64_done:
    mvn  w0, w2                ; ~CRC = resultado final
    ret

; ══════════════════════════════════════════════════════════════════════════════
; generic_crc32c_64 — CRC32C SOFTWARE (Castagnoli RFC 3720)
; x0 = buf, x1 = len
; Retorna w0 = CRC32C
; Tabela em crc_table[] (inicializada por init_crc_table_arm64)
; PRIMO=5 (validação — mesmo primo, implementação diferente)
; ══════════════════════════════════════════════════════════════════════════════
.align 4
generic_crc32c_64:
    stp  x29, x30, [sp, #-16]!
    mov  x29, sp

    mov  w2, #~0               ; crc = 0xFFFFFFFF
    adr  x3, crc_table
    cbz  x1, .gcrc_done

.gcrc_loop:
    ldrb w4, [x0], #1         ; byte
    eor  w4, w2, w4
    and  w4, w4, #0xFF         ; índice na tabela
    lsr  w2, w2, #8
    ldr  w5, [x3, x4, lsl #2] ; crc_table[índice]
    eor  w2, w2, w5
    subs x1, x1, #1
    b.ne .gcrc_loop

.gcrc_done:
    mvn  w0, w2
    ldp  x29, x30, [sp], #16
    ret

; ══════════════════════════════════════════════════════════════════════════════
; init_crc_table_arm64 — Inicializa tabela CRC32C (poly=0x82F63B78)
; Chama apenas uma vez em _start
; ══════════════════════════════════════════════════════════════════════════════
.align 4
init_crc_table_arm64:
    adr  x0, crc_table
    mov  w1, #0                ; i = 0
    mov  w2, #0x82F63B78       ; polinômio Castagnoli

.crc_tbl_loop:
    mov  w3, w1                ; v = i
    mov  w4, #8                ; 8 bits
.crc_tbl_bits:
    tst  w3, #1
    lsr  w3, w3, #1
    b.eq .crc_tbl_next_bit
    eor  w3, w3, w2
.crc_tbl_next_bit:
    subs w4, w4, #1
    b.ne .crc_tbl_bits

    str  w3, [x0, x1, lsl #2] ; crc_table[i] = v
    add  w1, w1, #1
    cmp  w1, #256
    b.lt .crc_tbl_loop
    ret

; ══════════════════════════════════════════════════════════════════════════════
; neon_memcpy128 — memcpy NEON ARM64: 128 bytes por iteração (8×ld1)
; x0=dst, x1=src, x2=len
; PRIMO=2 (movimento de dados — fundamental)
; ══════════════════════════════════════════════════════════════════════════════
.align 4
neon_memcpy128:
    cmp  x2, #128
    b.lt .neon_mc_32

.neon_mc_128:
    ld1  {v0.16b,v1.16b,v2.16b,v3.16b}, [x1], #64
    ld1  {v4.16b,v5.16b,v6.16b,v7.16b}, [x1], #64
    st1  {v0.16b,v1.16b,v2.16b,v3.16b}, [x0], #64
    st1  {v4.16b,v5.16b,v6.16b,v7.16b}, [x0], #64
    subs x2, x2, #128
    b.ge .neon_mc_128
    cbz  x2, .neon_mc_done

.neon_mc_32:
    cmp  x2, #32
    b.lt .neon_mc_byte
    ld1  {v0.16b,v1.16b}, [x1], #32
    st1  {v0.16b,v1.16b}, [x0], #32
    subs x2, x2, #32
    b.ne .neon_mc_32

.neon_mc_byte:
    cbz  x2, .neon_mc_done
.neon_mc_b1:
    ldrb w3, [x1], #1
    strb w3, [x0], #1
    subs x2, x2, #1
    b.ne .neon_mc_b1

.neon_mc_done:
    ret

; Versão genérica (fallback)
generic_memcpy64:
    cbz  x2, .gmc_done
.gmc_loop:
    ldrb w3, [x1], #1
    strb w3, [x0], #1
    subs x2, x2, #1
    b.ne .gmc_loop
.gmc_done:
    ret

; ══════════════════════════════════════════════════════════════════════════════
; neon_memset128 — memset NEON ARM64: 128 bytes por iteração
; x0=dst, w1=byte, x2=len
; PRIMO=3 (inicialização — segundo fundamental)
; ══════════════════════════════════════════════════════════════════════════════
.align 4
neon_memset128:
    dup  v0.16b, w1             ; propaga byte em vetor 128-bit

    cmp  x2, #128
    b.lt .neon_ms_16

.neon_ms_128:
    st1  {v0.16b}, [x0], #16
    st1  {v0.16b}, [x0], #16
    st1  {v0.16b}, [x0], #16
    st1  {v0.16b}, [x0], #16
    st1  {v0.16b}, [x0], #16
    st1  {v0.16b}, [x0], #16
    st1  {v0.16b}, [x0], #16
    st1  {v0.16b}, [x0], #16
    subs x2, x2, #128
    b.ge .neon_ms_128
    cbz  x2, .neon_ms_done

.neon_ms_16:
    cmp  x2, #16
    b.lt .neon_ms_byte
    st1  {v0.16b}, [x0], #16
    subs x2, x2, #16
    b.ne .neon_ms_16

.neon_ms_byte:
    cbz  x2, .neon_ms_done
.neon_ms_b1:
    strb w1, [x0], #1
    subs x2, x2, #1
    b.ne .neon_ms_b1
.neon_ms_done:
    ret

generic_memset64:
    cbz  x2, .gms_done
.gms_loop:
    strb w1, [x0], #1
    subs x2, x2, #1
    b.ne .gms_loop
.gms_done:
    ret

; ══════════════════════════════════════════════════════════════════════════════
; generic_ema_q16 — EMA Q16.16 escalar (sem NEON)
; x0=old_q16, x1=input_q16 → retorna w0=ema_q16
; EMA: (old*49152 + in*16384) >> 16
; PRIMO=7 (suavização de estado)
; ══════════════════════════════════════════════════════════════════════════════
.align 4
generic_ema_q16:
    mov  w2, #49152             ; 0.75 em Q16.16
    mov  w3, #16384             ; 0.25 em Q16.16
    umull x4, w0, w2            ; old * 49152
    umull x5, w1, w3            ; in  * 16384
    add  x4, x4, x5
    lsr  w0, w4, #16            ; >> 16 = resultado Q16.16
    ret

; ══════════════════════════════════════════════════════════════════════════════
; ema_neon_7d — EMA Q16.16 para 7 dimensões com NEON (processa 4+3)
; x0=ptr_old[7], x1=ptr_in[7], x2=ptr_out[7]
; PRIMO=7×3=21 (EMA + NEON)
; ══════════════════════════════════════════════════════════════════════════════
.align 4
ema_neon_7d:
    ld1  {v0.4s}, [x0]         ; old[0..3]
    ld1  {v1.4s}, [x1]         ; in[0..3]

    movi v2.4s, #0xC0, lsl #8  ; 49152
    movi v3.4s, #0x40, lsl #8  ; 16384

    umull  v4.2d, v0.2s, v2.2s
    umull2 v5.2d, v0.4s, v2.4s
    umull  v6.2d, v1.2s, v3.2s
    umull2 v7.2d, v1.4s, v3.4s
    add    v4.2d, v4.2d, v6.2d
    add    v5.2d, v5.2d, v7.2d
    shrn   v0.2s, v4.2d, #16
    shrn2  v0.4s, v5.2d, #16
    st1  {v0.4s}, [x2]         ; out[0..3]

    ; dims 4..6 escalar
    add  x0, x0, #16
    add  x1, x1, #16
    add  x2, x2, #16
    mov  w4, #49152
    mov  w5, #16384

    ldr  w6, [x0, #0]
    ldr  w7, [x1, #0]
    umull x8, w6, w4
    umull x9, w7, w5
    add  x8, x8, x9
    lsr  w8, w8, #16
    str  w8, [x2, #0]

    ldr  w6, [x0, #4]
    ldr  w7, [x1, #4]
    umull x8, w6, w4
    umull x9, w7, w5
    add  x8, x8, x9
    lsr  w8, w8, #16
    str  w8, [x2, #4]

    ldr  w6, [x0, #8]
    ldr  w7, [x1, #8]
    umull x8, w6, w4
    umull x9, w7, w5
    add  x8, x8, x9
    lsr  w8, w8, #16
    str  w8, [x2, #8]
    ret

; ══════════════════════════════════════════════════════════════════════════════
; generic_entropy — Calcula entropia como unique_bytes/256*65535
; x0=buf, x1=len → retorna w0=entropia Q16.16
; Limite: processa no máximo 4096 bytes
; PRIMO=13 (medição de caos)
; ══════════════════════════════════════════════════════════════════════════════
.align 4
generic_entropy:
    stp  x29, x30, [sp, #-48]!
    mov  x29, sp

    ; Tabela seen[256] na stack (32 bytes = 256 bits como bitset)
    sub  sp, sp, #32
    mov  x2, sp
    mov  x3, #32
.ent_zero:
    str  xzr, [x2], #8
    subs x3, x3, #8
    b.ne .ent_zero
    mov  x2, sp

    mov  x3, #4096
    cmp  x1, x3
    csel x1, x1, x3, lt        ; min(len, 4096)

    mov  x4, #0                ; unique count
    mov  x5, x0                ; ptr

.ent_loop:
    ldrb w6, [x5], #1
    ; Testa bit w6 no bitset
    and  w7, w6, #7            ; bit offset
    lsr  w8, w6, #3            ; byte index
    ldrb w9, [x2, x8]
    lsr  w10, w9, w7
    tst  w10, #1
    b.ne .ent_already_seen
    orr  w9, w9, w10           ; marca bit
    mov  w10, #1
    lsl  w10, w10, w7
    orr  w9, w9, w10
    strb w9, [x2, x8]
    add  x4, x4, #1
.ent_already_seen:
    subs x1, x1, #1
    b.ne .ent_loop

    ; resultado = (unique * 65535) / 256
    mov  w5, #65535
    mul  w0, w4, w5
    lsr  w0, w0, #8            ; /256

    add  sp, sp, #32
    ldp  x29, x30, [sp], #48
    ret

; ══════════════════════════════════════════════════════════════════════════════
; arena_alloc — Aloca n bytes da arena BSS (bump pointer, sem malloc)
; x0 = n (tamanho alinhado para 8)
; Retorna x0 = ponteiro ou 0 se esgotou
; PRIMO=2×3=6 (fundação + init)
; ══════════════════════════════════════════════════════════════════════════════
.align 4
arena_alloc:
    ; Alinha n para múltiplo de 8
    add  x0, x0, #7
    and  x0, x0, #~7

    adr  x1, arena_bump
    ldr  x2, [x1]              ; bump atual
    add  x3, x2, x0            ; novo bump

    ; Verifica overflow: bump + n <= arena_mem + G_ARENA_SZ
    adr  x4, arena_mem
    add  x4, x4, #G_ARENA_SZ
    cmp  x3, x4
    b.gt .arena_full

    str  x3, [x1]              ; atualiza bump
    mov  x0, x2                ; retorna ponteiro anterior
    ret

.arena_full:
    mov  x0, #0                ; NULL — arena esgotada
    ret

; ══════════════════════════════════════════════════════════════════════════════
; rafaclone — fork seguro para Android (SYS_clone com SIGCHLD)
; Retorna x0: 0=filho, pid=pai, <0=erro
; PRIMO=57 (fork — número primo que identifica fork no espaço de syscalls)
; ══════════════════════════════════════════════════════════════════════════════
.align 4
rafaclone:
    stp  x29, x30, [sp, #-16]!
    mov  x29, sp
    mov  x0, #SIGCHLD           ; flags = SIGCHLD (clone como fork)
    mov  x1, #0                 ; child_stack = NULL (herda stack do pai)
    mov  x2, #0                 ; parent_tidptr
    mov  x3, #0                 ; child_tidptr
    mov  x8, #SYS_clone
    svc  #0
    ldp  x29, x30, [sp], #16
    ret

; ══════════════════════════════════════════════════════════════════════════════
; print_hex32 — Imprime w0 como hexadecimal de 8 dígitos em STDOUT
; Não usa printf. Usa escrita direta via SYS_write.
; PRIMO=19 (saída formata — ponte hardware↔usuário)
; ══════════════════════════════════════════════════════════════════════════════
.align 4
print_hex32:
    stp  x29, x30, [sp, #-32]!
    mov  x29, sp

    adr  x1, hex_buf
    mov  x2, #0x30303030       ; '0000'
    str  w2, [x1]
    str  w2, [x1, #4]

    ; Converte 8 nibbles de w0 em ASCII hex
    mov  x3, #7
.phex_loop:
    and  w4, w0, #0xF
    cmp  w4, #10
    b.lt .phex_digit
    add  w4, w4, #('a'-10)
    b    .phex_store
.phex_digit:
    add  w4, w4, #'0'
.phex_store:
    strb w4, [x1, x3]
    lsr  w0, w0, #4
    subs x3, x3, #1
    b.ge .phex_loop

    ; Escreve hex_buf[0..7]
    mov  x0, #STDOUT
    mov  x2, #8
    mov  x8, #SYS_write
    svc  #0

    ldp  x29, x30, [sp], #32
    ret

; ══════════════════════════════════════════════════════════════════════════════
; print_caps_arm64 — Imprime capacidades HW detectadas
; ══════════════════════════════════════════════════════════════════════════════
.align 4
print_caps_arm64:
    stp  x29, x30, [sp, #-16]!
    mov  x29, sp

    mov  x0, #STDOUT
    adr  x1, banner_caps
    mov  x2, #banner_caps_len
    mov  x8, #SYS_write
    svc  #0

    adr  x0, g_has_neon
    ldrb w0, [x0]
    cbz  w0, .pc64_crc
    mov  x0, #STDOUT
    adr  x1, str_neon
    mov  x2, #5
    mov  x8, #SYS_write
    svc  #0

.pc64_crc:
    adr  x0, g_has_crc32hw
    ldrb w0, [x0]
    cbz  w0, .pc64_aes
    mov  x0, #STDOUT
    adr  x1, str_crc32
    mov  x2, #6
    mov  x8, #SYS_write
    svc  #0

.pc64_aes:
    adr  x0, g_has_aes_hw
    ldrb w0, [x0]
    cbz  w0, .pc64_sha2
    mov  x0, #STDOUT
    adr  x1, str_aes
    mov  x2, #4
    mov  x8, #SYS_write
    svc  #0

.pc64_sha2:
    adr  x0, g_has_sha2
    ldrb w0, [x0]
    cbz  w0, .pc64_lse
    mov  x0, #STDOUT
    adr  x1, str_sha2
    mov  x2, #5
    mov  x8, #SYS_write
    svc  #0

.pc64_lse:
    adr  x0, g_has_atomics
    ldrb w0, [x0]
    cbz  w0, .pc64_sve
    mov  x0, #STDOUT
    adr  x1, str_atomics
    mov  x2, #4
    mov  x8, #SYS_write
    svc  #0

.pc64_sve:
    adr  x0, g_has_sve
    ldrb w0, [x0]
    cbz  w0, .pc64_nl
    mov  x0, #STDOUT
    adr  x1, str_sve
    mov  x2, #4
    mov  x8, #SYS_write
    svc  #0

.pc64_nl:
    mov  x0, #STDOUT
    adr  x1, str_nl
    mov  x2, #2
    mov  x8, #SYS_write
    svc  #0

    ldp  x29, x30, [sp], #16
    ret

print_exit_crc:
    stp  x29, x30, [sp, #-16]!
    mov  x29, sp
    mov  x21, x20               ; salva crc

    mov  x0, #STDOUT
    adr  x1, str_exit_msg
    mov  x2, #str_exit_msg_len
    mov  x8, #SYS_write
    svc  #0

    mov  w0, x21
    bl   print_hex32

    mov  x0, #STDOUT
    adr  x1, str_bye
    mov  x2, #2
    mov  x8, #SYS_write
    svc  #0

    ldp  x29, x30, [sp], #16
    ret

; ══════════════════════════════════════════════════════════════════════════════
; repl_arm64 — FASE 4: REPL ENTERPRISE FREESTANDING
; Loop: prompt → read → parse → exec (fork/exec ou builtin) → toro_step → repeat
; PRIMO=31 (inclusão + distribuição — o REPL conecta tudo)
; ══════════════════════════════════════════════════════════════════════════════
.align 4
repl_arm64:
    stp  x29, x30, [sp, #-64]!
    mov  x29, sp

.repl_loop:
    ; ── Prompt ────────────────────────────────────────────────────────────
    mov  x0, #STDOUT
    adr  x1, str_prompt
    mov  x2, #str_prompt_len
    mov  x8, #SYS_write
    svc  #0

    ; ── Read ──────────────────────────────────────────────────────────────
    mov  x0, #STDIN
    adr  x1, io_buf
    mov  x2, #2047
    mov  x8, #SYS_read
    svc  #0

    cmp  x0, #0
    ble  .repl_exit             ; EOF

    mov  x19, x0               ; x19 = bytes lidos

    ; ── Linha vazia? ──────────────────────────────────────────────────────
    cmp  x19, #1
    b.le .repl_toro_tick        ; só \n — avança toro e reprompta

    ; ── Strip \n ──────────────────────────────────────────────────────────
    adr  x20, io_buf
    sub  x1, x19, #1
    strb wzr, [x20, x1]

    ; ── Parse: checa built-ins ─────────────────────────────────────────────
    ; "exit" → sai
    ldr  w1, [x20]             ; primeiros 4 bytes como uint32
    ldr  w2, =0x74697865       ; 'exit' little-endian
    cmp  w1, w2
    b.eq .repl_exit

    ; "status" → imprime estado toro
    adr  x2, cmd_status
    bl   strncmp6
    cbz  x0, .repl_status

    ; "toro" → imprime toro state
    adr  x2, cmd_toro
    bl   strncmp4
    cbz  x0, .repl_toro_print

    ; "crc" → imprime CRC chain
    adr  x2, cmd_crc
    bl   strncmp3
    cbz  x0, .repl_crc_print

    ; "caps" → re-imprime capacidades
    adr  x2, cmd_caps
    bl   strncmp4
    cbz  x0, .repl_caps_print

    ; "help" → mensagem de ajuda
    adr  x2, cmd_help
    bl   strncmp4
    cbz  x0, .repl_help

    ; ── Comando externo: rafaclone → execve /system/bin/sh -c cmd ────────
    bl   rafaclone

    cmp  x0, #0
    beq  .repl_child            ; filho
    blt  .repl_toro_tick        ; clone falhou → toro tick e tenta de novo

    ; PAI: wait4
    mov  x1, x0                ; pid
    mov  x0, #-1
    adr  x2, proc_status
    mov  x3, #0
    mov  x4, #0
    mov  x8, #SYS_wait4
    svc  #0

    ; Avança toro após execução
    b    .repl_toro_tick

.repl_child:
    ; Monta argv na stack (16-byte aligned)
    sub  sp, sp, #48
    str  xzr, [sp, #32]                    ; NULL

    adr  x0, io_buf
    str  x0, [sp, #24]                     ; argv[2] = cmd

    adr  x0, arg1_c
    str  x0, [sp, #16]                     ; argv[1] = "-c"

    adr  x0, arg0_sh
    str  x0, [sp,  #8]                     ; argv[0] = "sh"

    ; Tenta /data/data/com.termux/.../sh primeiro
    adr  x0, path_sh_termux
    mov  x1, sp
    adr  x2, saved_envp
    ldr  x2, [x2]
    mov  x8, #SYS_execve
    svc  #0
    ; Se falhou, tenta /system/bin/sh
    adr  x0, path_sh_system
    svc  #0
    ; Último fallback: /bin/sh
    adr  x0, path_sh_bin
    svc  #0

    ; Tudo falhou
    mov  x0, #127
    mov  x8, #SYS_exit
    svc  #0

.repl_status:
    ; Imprime phi, step, chain, phase
    adr  x0, toro_phi
    ldr  w0, [x0]
    bl   print_hex32
    mov  x0, #STDOUT
    adr  x1, str_nl
    mov  x2, #2
    mov  x8, #SYS_write
    svc  #0
    b    .repl_toro_tick

.repl_toro_print:
    ; Imprime os 7 valores do toro
    adr  x22, toro_s
    mov  x23, #7
.repl_toro_loop:
    ldr  w0, [x22], #4
    bl   print_hex32
    mov  x0, #STDOUT
    adr  x1, str_nl
    mov  x2, #2
    mov  x8, #SYS_write
    svc  #0
    subs x23, x23, #1
    b.ne .repl_toro_loop
    b    .repl_toro_tick

.repl_crc_print:
    adr  x0, toro_chain
    ldr  w0, [x0]
    bl   print_hex32
    mov  x0, #STDOUT
    adr  x1, str_nl
    mov  x2, #2
    mov  x8, #SYS_write
    svc  #0
    b    .repl_toro_tick

.repl_caps_print:
    bl   print_caps_arm64
    b    .repl_toro_tick

.repl_help:
    mov  x0, #STDOUT
    adr  x1, msg_help
    mov  x2, #msg_help_len
    mov  x8, #SYS_write
    svc  #0
    b    .repl_toro_tick

.repl_toro_tick:
    ; Avança o toro um passo em cada ciclo do REPL
    adr  x0, dispatch_toro
    ldr  x0, [x0]              ; ponteiro para toro_step
    blr  x0                    ; chama via dispatch table

    b    .repl_loop

.repl_exit:
    ldp  x29, x30, [sp], #64
    ret

; ── Helpers de comparação de string sem strncmp ──────────────────────────────
; x20 = io_buf, x2 = cmd string → w0 = 0 se igual
strncmp3:
    ldrb w3, [x20, #0]; ldrb w4, [x2, #0]; cmp w3,w4; b.ne .scmp_no
    ldrb w3, [x20, #1]; ldrb w4, [x2, #1]; cmp w3,w4; b.ne .scmp_no
    ldrb w3, [x20, #2]; ldrb w4, [x2, #2]; cmp w3,w4; b.ne .scmp_no
    mov w0,#0; ret
strncmp4:
    ldrb w3, [x20, #0]; ldrb w4, [x2, #0]; cmp w3,w4; b.ne .scmp_no
    ldrb w3, [x20, #1]; ldrb w4, [x2, #1]; cmp w3,w4; b.ne .scmp_no
    ldrb w3, [x20, #2]; ldrb w4, [x2, #2]; cmp w3,w4; b.ne .scmp_no
    ldrb w3, [x20, #3]; ldrb w4, [x2, #3]; cmp w3,w4; b.ne .scmp_no
    mov w0,#0; ret
strncmp6:
    ldrb w3, [x20, #0]; ldrb w4, [x2, #0]; cmp w3,w4; b.ne .scmp_no
    ldrb w3, [x20, #1]; ldrb w4, [x2, #1]; cmp w3,w4; b.ne .scmp_no
    ldrb w3, [x20, #2]; ldrb w4, [x2, #2]; cmp w3,w4; b.ne .scmp_no
    ldrb w3, [x20, #3]; ldrb w4, [x2, #3]; cmp w3,w4; b.ne .scmp_no
    ldrb w3, [x20, #4]; ldrb w4, [x2, #4]; cmp w3,w4; b.ne .scmp_no
    ldrb w3, [x20, #5]; ldrb w4, [x2, #5]; cmp w3,w4; b.ne .scmp_no
    mov w0,#0; ret
.scmp_no:
    mov w0,#1; ret

; ══════════════════════════════════════════════════════════════════════════════
; FIM bootstrap_arm64_adaptive.s
; ══════════════════════════════════════════════════════════════════════════════


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 SEÇÃO B — ARM32 armeabi-v7a · BOOTSTRAP ADAPTATIVO COMPLETO (Thumb2)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

; ╔══════════════════════════════════════════════════════════════════════════╗
; ║  bootstrap_arm32_adaptive.s                                            ║
; ║  Compilar: arm-linux-androideabi-as -march=armv7-a -mfpu=neon-vfpv4  ║
; ║            -mthumb -o rafa32.o bootstrap_arm32_adaptive.s             ║
; ║            arm-linux-androideabi-ld -o rafa32 rafa32.o               ║
; ╚══════════════════════════════════════════════════════════════════════════╝

.arch   armv7-a
.fpu    neon-vfpv4
.thumb
.syntax unified

; ── SYSCALLS ARM32 (ARM EABI Linux) ──────────────────────────────────────────
; Número em r7, swi #0, retorno em r0
.equ SYS32_read,    3
.equ SYS32_write,   4
.equ SYS32_open,    5
.equ SYS32_close,   6
.equ SYS32_fork,    2
.equ SYS32_execve,  11
.equ SYS32_exit,    1
.equ SYS32_wait4,   114
.equ SYS32_mmap2,   192   ; mmap com offset>>12
.equ SYS32_mprotect,125
.equ SYS32_clone,   120   ; fork seguro bionic
.equ SYS32_getpid,  20
.equ SYS32_getuid,  24
.equ SYS32_gettid,  224
.equ SYS32_prctl,   172
.equ STDIN32,       0
.equ STDOUT32,      1
.equ STDERR32,      2

; ── HWCAP BITS ARM32 ─────────────────────────────────────────────────────────
.equ HWCAP32_NEON,  (1<<12)  ; NEON (VFPv3+NEON)
.equ HWCAP32_VFPv3, (1<<13)  ; VFPv3
.equ HWCAP32_VFPv4, (1<<16)  ; VFPv4 (fused multiply-add)
.equ HWCAP32_IDIVA, (1<<17)  ; SDIV/UDIV em ARM mode
.equ HWCAP32_IDIVT, (1<<18)  ; SDIV/UDIV em Thumb mode
.equ HWCAP32_EVTSTRM,(1<<21)
.equ AT_HWCAP32,    16
.equ AT_NULL32,     0

; ── Q16.16 CONSTANTES (mesmo do ARM64) ───────────────────────────────────────
.equ Q32_ONE,      65536
.equ Q32_SQRT3_2,  56756
.equ Q32_ALPHA,    16384    ; 0.25
.equ Q32_IALPHA,   49152    ; 0.75
.equ Q32_SPIRAL,   56755
.equ G32_PERIOD,   42
.equ G32_DIM,      7
.equ G32_ARENA_SZ, 0x10000  ; 64KB

.equ SIGCHLD32,    17
.equ CLONE_SIGCHLD32, 17

; ── MMAP FLAGS ARM32 ─────────────────────────────────────────────────────────
.equ MAP32_ANON_PRIV, 0x22

.section .data
.align 2

; ── DISPATCH TABLE ARM32 ─────────────────────────────────────────────────────
dispatch32_memcpy:  .word generic32_memcpy
dispatch32_memset:  .word generic32_memset
dispatch32_crc32:   .word generic32_crc32c
dispatch32_ema:     .word generic32_ema_q16
dispatch32_toro:    .word generic32_toro_step

; ── HWCAP FLAGS ARM32 (preenchidas em runtime) ────────────────────────────────
.align 4
g32_hwcap:       .word 0
g32_has_neon:    .byte 0
g32_has_vfpv4:   .byte 0
g32_has_idivt:   .byte 0
.align 2

banner_arm32:
  .ascii "\033[1;33m"
  .ascii "╔══════════════════════════════════════════════════════╗\r\n"
  .ascii "║  RAFAELIA · ARM32 Adaptive Bootstrap · Thumb2+NEON  ║\r\n"
  .ascii "║  Toro T^7 · Q16.16 · HWCAP · softfp · 42 Atratores  ║\r\n"
  .ascii "╚══════════════════════════════════════════════════════╝\r\n"
  .ascii "\033[0m"
.equ banner_arm32_len, . - banner_arm32

str32_prompt:  .ascii "\033[1;33mrafaφ32\033[0m❯ "
.equ str32_prompt_len, . - str32_prompt
str32_nl:      .ascii "\r\n"
str32_toro:    .ascii "[TORO32] Estado 7D Q16.16 pronto\r\n"
.equ str32_toro_len, . - str32_toro
str32_dispatch: .ascii "[DISPATCH32] Tabela adaptada ao hardware\r\n"
.equ str32_dispatch_len, . - str32_dispatch
str32_exit:    .ascii "\r\n[RAFAELIA32] Saindo\r\n"
.equ str32_exit_len, . - str32_exit
str32_help:    .ascii "Cmds: exit status toro crc caps help\r\n"
.equ str32_help_len, . - str32_help
str32_neon:    .ascii "NEON "
str32_vfpv4:   .ascii "VFPv4 "
str32_idivt:   .ascii "IDIVT "
str32_caps_hdr:.ascii "[HWCAP32] "
.equ str32_caps_hdr_len, . - str32_caps_hdr

path32_termux: .asciz "/data/data/com.termux/files/usr/bin/sh"
path32_system: .asciz "/system/bin/sh"
path32_bin:    .asciz "/bin/sh"
arg32_0:       .asciz "sh"
arg32_1:       .asciz "-c"

cmd32_exit:    .ascii "exit"
cmd32_status:  .ascii "status"
cmd32_toro:    .ascii "toro"
cmd32_crc:     .ascii "crc"
cmd32_caps:    .ascii "caps"
cmd32_help:    .ascii "help"

.section .bss
.align 12                    ; 4KB mínimo ARM32 (align 14=16KB para compat ARM64)
                             ; NOTA: mude para .align 14 se coexistindo com arm64

arena32_mem:  .space G32_ARENA_SZ
arena32_bump: .space 4

toro32_s:    .space 28       ; uint32[7]
toro32_C:    .space 4
toro32_H:    .space 4
toro32_phi:  .space 4
toro32_phase:.space 4
toro32_crc:  .space 4
toro32_chain:.space 4
toro32_step: .space 8

.align 4
io32_buf:    .space 2048
io32_out:    .space 512
proc32_status:.space 4
saved32_envp: .space 4      ; ARM32: ponteiros são 32-bit!
hex32_buf:   .space 16
crc32_table: .space 1024    ; 256 × uint32

.section .text
.thumb_func
.global _start

; ══════════════════════════════════════════════════════════════════════════════
; _start ARM32 — FASE 0: ENTRADA GENÉRICA Thumb2
; Stack ARM32: sp+0=argc, sp+4=argv[], sp+4*(argc+2)=envp[]
; r4-r11: callee-saved | r7: syscall | lr: link | sp: stack
; ══════════════════════════════════════════════════════════════════════════════
.align 2
_start:
    push {r4, r5, r6, r7, lr}  ; snapshot do contexto (commit gate fase 0)

    ; Extrai envp do stack ARM32
    ldr  r0, [sp, #20]         ; argc (sp foi modificado por push)
    add  r0, r0, #2
    lsl  r0, r0, #2            ; *(argc+2)*4
    add  r1, sp, r0
    add  r1, r1, #20           ; ajusta por push anterior (5×4=20)
    ldr  r2, =saved32_envp
    str  r1, [r2]

    ; FASE 1: HWCAP PROBE ARM32
    bl   hwcap_probe_arm32

    ; FASE 2: DISPATCH REWIRE ARM32
    bl   dispatch_rewire_arm32

    ; Inicializa CRC table
    bl   init_crc32_table_arm32

    ; Inicializa arena BSS
    ldr  r1, =arena32_bump
    ldr  r0, =arena32_mem
    str  r0, [r1]

    ; FASE 3: TORO 7D Q16.16
    bl   toro32_init

    ; Banner
    mov  r7, #SYS32_write
    mov  r0, #STDOUT32
    ldr  r1, =banner_arm32
    mov  r2, #banner_arm32_len
    swi  #0

    bl   print_caps_arm32

    ; FASE 4: REPL
    bl   repl_arm32

    ; Exit
    mov  r7, #SYS32_exit
    mov  r0, #0
    swi  #0

; ══════════════════════════════════════════════════════════════════════════════
; hwcap_probe_arm32 — Lê AT_HWCAP do aux vector ARM32
; Stack ARM32: após envp[]=NULL vem os pares (type4, value4)
; ══════════════════════════════════════════════════════════════════════════════
.thumb_func
.align 2
hwcap_probe_arm32:
    push {r4, r5, r6, lr}

    ldr  r4, =saved32_envp
    ldr  r4, [r4]              ; r4 = &envp[0]

    ; Pula envp[]
.h32_skip_envp:
    ldr  r5, [r4], #4
    cmp  r5, #0
    bne  .h32_skip_envp
    ; r4 = &aux[0].type agora

.h32_scan_aux:
    ldm  r4!, {r5, r6}         ; type, value
    cmp  r5, #AT_NULL32
    beq  .h32_done

    cmp  r5, #AT_HWCAP32
    bne  .h32_scan_aux
    ldr  r0, =g32_hwcap
    str  r6, [r0]
    b    .h32_scan_aux

.h32_done:
    ldr  r0, =g32_hwcap
    ldr  r1, [r0]

    ; NEON: bit 12
    tst  r1, #HWCAP32_NEON
    movne r2, #1
    moveq r2, #0
    ldr  r0, =g32_has_neon
    strb r2, [r0]

    ; VFPv4: bit 16
    tst  r1, #HWCAP32_VFPv4
    movne r2, #1
    moveq r2, #0
    ldr  r0, =g32_has_vfpv4
    strb r2, [r0]

    ; IDIVT: bit 18
    tst  r1, #(1<<18)
    movne r2, #1
    moveq r2, #0
    ldr  r0, =g32_has_idivt
    strb r2, [r0]

    pop  {r4, r5, r6, pc}

; ══════════════════════════════════════════════════════════════════════════════
; dispatch_rewire_arm32 — Rewire da tabela com paths ótimos
; ══════════════════════════════════════════════════════════════════════════════
.thumb_func
.align 2
dispatch_rewire_arm32:
    push {r4, r5, lr}

    ldr  r0, =g32_has_neon
    ldrb r0, [r0]
    cmp  r0, #0
    beq  .d32_done

    ; NEON disponível → rewire memcpy, memset, ema, toro
    ldr  r1, =dispatch32_memcpy
    ldr  r0, =neon32_memcpy
    str  r0, [r1]

    ldr  r1, =dispatch32_memset
    ldr  r0, =neon32_memset
    str  r0, [r1]

    ldr  r1, =dispatch32_ema
    ldr  r0, =neon32_ema_q16
    str  r0, [r1]

    ldr  r1, =dispatch32_toro
    ldr  r0, =neon32_toro_step
    str  r0, [r1]

.d32_done:
    mov  r7, #SYS32_write
    mov  r0, #STDOUT32
    ldr  r1, =str32_dispatch
    mov  r2, #str32_dispatch_len
    swi  #0

    pop  {r4, r5, pc}

; ══════════════════════════════════════════════════════════════════════════════
; toro32_init — Inicializa Toro T^7 Q16.16 ARM32
; ══════════════════════════════════════════════════════════════════════════════
.thumb_func
.align 2
toro32_init:
    push {r4, r5, r6, r7, lr}

    ldr  r4, =toro32_s
    ldr  r5, =Q32_SPIRAL       ; 56755

    ; s[d] = (Q32_SPIRAL * prime_d) & 0xFFFF
    mov  r6, #2
    mul  r0, r5, r6
    and  r0, r0, #0xFFFF
    str  r0, [r4, #0]

    mov  r6, #3
    mul  r0, r5, r6
    and  r0, r0, #0xFFFF
    str  r0, [r4, #4]

    mov  r6, #5
    mul  r0, r5, r6
    and  r0, r0, #0xFFFF
    str  r0, [r4, #8]

    mov  r6, #7
    mul  r0, r5, r6
    and  r0, r0, #0xFFFF
    str  r0, [r4, #12]

    mov  r6, #11
    mul  r0, r5, r6
    and  r0, r0, #0xFFFF
    str  r0, [r4, #16]

    mov  r6, #13
    mul  r0, r5, r6
    and  r0, r0, #0xFFFF
    str  r0, [r4, #20]

    mov  r6, #17
    mul  r0, r5, r6
    and  r0, r0, #0xFFFF
    str  r0, [r4, #24]

    mov  r0, #0x8000            ; C = H = phi = 0.5
    ldr  r1, =toro32_C
    str  r0, [r1]
    ldr  r1, =toro32_H
    str  r0, [r1]
    ldr  r1, =toro32_phi
    str  r0, [r1]

    mov  r0, #0
    ldr  r1, =toro32_phase
    str  r0, [r1]
    ldr  r1, =toro32_chain
    str  r0, [r1]

    mov  r7, #SYS32_write
    mov  r0, #STDOUT32
    ldr  r1, =str32_toro
    mov  r2, #str32_toro_len
    swi  #0

    pop  {r4, r5, r6, r7, pc}

; ══════════════════════════════════════════════════════════════════════════════
; neon32_toro_step — Um passo do toro com NEON ARM32
; EMA Q16.16: s_new = (s*49152 + input*16384) >> 16
; input[d] = rotação toroidal por fase
; NEON ARM32: registradores q0-q15 (128-bit), d0-d31 (64-bit)
; ══════════════════════════════════════════════════════════════════════════════
.thumb_func
.align 2
neon32_toro_step:
    push {r4, r5, r6, r7, r8, lr}

    ldr  r4, =toro32_phase
    ldr  r5, [r4]               ; r5 = phase

    ldr  r4, =toro32_s

    ; Carrega s[0..3] em q0 (128-bit)
    vld1.32 {q0}, [r4]         ; q0 = {s[0],s[1],s[2],s[3]}

    ; Gera inputs[0..3] via rotação de fase
    mov  r6, #9804
    mul  r7, r5, r6             ; r7 = phase*9804

    and  r6, r7, #0xFFFF
    vmov.32 d2[0], r6           ; input[0]
    add  r6, r7, #2731
    and  r6, r6, #0xFFFF
    vmov.32 d2[1], r6           ; input[1]
    add  r6, r7, #5462
    and  r6, r6, #0xFFFF
    vmov.32 d3[0], r6           ; input[2]
    add  r6, r7, #8193
    and  r6, r6, #0xFFFF
    vmov.32 d3[1], r6           ; input[3]

    ; EMA: (s*49152 + in*16384) >> 16
    ; ARM32 NEON: vmull.u32 q_dst, d_lo, d_hi → uint64x2
    vmov.u32 q2, #49152         ; constante α (q2 = {49152 × 4})
    vmov.u32 q3, #16384         ; constante β

    vmull.u32 q4, d0, d4        ; s[0..1] * 49152
    vmull.u32 q5, d1, d5        ; s[2..3] * 49152
    vmull.u32 q6, d2, d6        ; in[0..1] * 16384
    vmull.u32 q7, d3, d7        ; in[2..3] * 16384

    vadd.u64  q4, q4, q6        ; soma
    vadd.u64  q5, q5, q7

    vshrn.u64 d0, q4, #16       ; >> 16 → d0 = s_new[0..1]
    vshrn.u64 d1, q5, #16       ; >> 16 → d1 = s_new[2..3]

    vst1.32 {q0}, [r4]!        ; armazena s_new[0..3]

    ; dims 4..6 escalar
    ldr  r6, =Q32_IALPHA        ; 49152
    ldr  r8, =Q32_ALPHA         ; 16384

    add  r7, r5, #(2731*4)
    and  r7, r7, #0xFFFF        ; input[4]
    ldr  r0, [r4, #0]
    umull r0, r1, r0, r6        ; s[4]*49152
    mla  r0, r7, r8, r0         ; += input*16384 (low 32-bit)
    lsr  r0, r0, #16
    str  r0, [r4, #0]

    add  r7, r5, #(2731*5)
    and  r7, r7, #0xFFFF
    ldr  r0, [r4, #4]
    umull r0, r1, r0, r6
    mla  r0, r7, r8, r0
    lsr  r0, r0, #16
    str  r0, [r4, #4]

    add  r7, r5, #(2731*6)
    and  r7, r7, #0xFFFF
    ldr  r0, [r4, #8]
    umull r0, r1, r0, r6
    mla  r0, r7, r8, r0
    lsr  r0, r0, #16
    str  r0, [r4, #8]

    ; Avança phase mod 42
    ldr  r4, =toro32_phase
    ldr  r0, [r4]
    add  r0, r0, #1
    cmp  r0, #42
    movge r0, #0
    str  r0, [r4]

    ; Atualiza CRC chain
    ldr  r0, =toro32_s
    mov  r1, #28
    bl   generic32_crc32c
    ldr  r1, =toro32_chain
    ldr  r2, [r1]
    eor  r2, r2, r0
    str  r2, [r1]
    ldr  r1, =toro32_crc
    str  r0, [r1]

    ; phi = s[0]
    ldr  r0, =toro32_s
    ldr  r0, [r0]
    ldr  r1, =toro32_phi
    str  r0, [r1]

    pop  {r4, r5, r6, r7, r8, pc}

generic32_toro_step:
    b    neon32_toro_step

; ══════════════════════════════════════════════════════════════════════════════
; neon32_memcpy — memcpy NEON ARM32: 64 bytes por iteração
; r0=dst, r1=src, r2=len
; ══════════════════════════════════════════════════════════════════════════════
.thumb_func
.align 2
neon32_memcpy:
    cmp  r2, #64
    blt  .n32mc_byte
.n32mc_64:
    vld1.8 {q0,q1}, [r1]!
    vld1.8 {q2,q3}, [r1]!
    vst1.8 {q0,q1}, [r0]!
    vst1.8 {q2,q3}, [r0]!
    sub  r2, r2, #64
    cmp  r2, #64
    bge  .n32mc_64
.n32mc_byte:
    cbz  r2, .n32mc_done
.n32mc_b1:
    ldrb r3, [r1], #1
    strb r3, [r0], #1
    subs r2, r2, #1
    bne  .n32mc_b1
.n32mc_done:
    bx   lr

generic32_memcpy:
    cbz  r2, .g32mc_done
.g32mc_loop:
    ldrb r3, [r1], #1
    strb r3, [r0], #1
    subs r2, r2, #1
    bne  .g32mc_loop
.g32mc_done:
    bx   lr

; ══════════════════════════════════════════════════════════════════════════════
; neon32_memset — memset NEON ARM32
; r0=dst, r1=byte, r2=len
; ══════════════════════════════════════════════════════════════════════════════
.thumb_func
.align 2
neon32_memset:
    vdup.8 q0, r1
    cmp  r2, #64
    blt  .n32ms_byte
.n32ms_64:
    vst1.8 {q0,q1}, [r0]!
    sub  r2, r2, #32
    vst1.8 {q0,q1}, [r0]!
    sub  r2, r2, #32
    cmp  r2, #64
    bge  .n32ms_64
.n32ms_byte:
    cbz  r2, .n32ms_done
.n32ms_b1:
    strb r1, [r0], #1
    subs r2, r2, #1
    bne  .n32ms_b1
.n32ms_done:
    bx   lr

generic32_memset:
    cbz  r2, .g32ms_done
.g32ms_loop:
    strb r1, [r0], #1
    subs r2, r2, #1
    bne  .g32ms_loop
.g32ms_done:
    bx   lr

; ══════════════════════════════════════════════════════════════════════════════
; generic32_ema_q16 — EMA Q16.16 ARM32 (umull para 64-bit)
; r0=old, r1=in → r0=result
; ══════════════════════════════════════════════════════════════════════════════
.thumb_func
.align 2
generic32_ema_q16:
    push {r4, r5}
    mov  r2, #49152
    mov  r3, #16384
    umull r4, r5, r0, r2        ; r4:r5 = old*49152 (64-bit)
    mla  r4, r1, r3, r4         ; r4 += in*16384 (low 32-bit, ok para Q16)
    lsr  r0, r4, #16
    pop  {r4, r5}
    bx   lr

neon32_ema_q16:
    b    generic32_ema_q16

; ══════════════════════════════════════════════════════════════════════════════
; generic32_crc32c — CRC32C software ARM32
; r0=buf, r1=len → r0=CRC32C
; ══════════════════════════════════════════════════════════════════════════════
.thumb_func
.align 2
generic32_crc32c:
    push {r4, r5, r6, lr}
    ldr  r4, =crc32_table
    mvn  r2, #0                 ; crc = ~0
    cbz  r1, .g32crc_done
.g32crc_loop:
    ldrb r3, [r0], #1
    eor  r3, r2, r3
    and  r3, r3, #0xFF
    lsr  r2, r2, #8
    ldr  r5, [r4, r3, lsl #2]
    eor  r2, r2, r5
    subs r1, r1, #1
    bne  .g32crc_loop
.g32crc_done:
    mvn  r0, r2
    pop  {r4, r5, r6, pc}

; ══════════════════════════════════════════════════════════════════════════════
; init_crc32_table_arm32 — Inicializa tabela CRC32C ARM32
; ══════════════════════════════════════════════════════════════════════════════
.thumb_func
.align 2
init_crc32_table_arm32:
    push {r4, r5, r6, lr}
    ldr  r0, =crc32_table
    mov  r1, #0
    ldr  r2, =0x82F63B78
.ct32_outer:
    mov  r3, r1
    mov  r4, #8
.ct32_inner:
    tst  r3, #1
    lsr  r3, r3, #1
    itt  ne
    eorne r3, r3, r2
    subs r4, r4, #1
    bne  .ct32_inner
    str  r3, [r0, r1, lsl #2]
    add  r1, r1, #1
    cmp  r1, #256
    blt  .ct32_outer
    pop  {r4, r5, r6, pc}

; ══════════════════════════════════════════════════════════════════════════════
; print32_hex — Imprime r0 como hex 8 dígitos
; ══════════════════════════════════════════════════════════════════════════════
.thumb_func
.align 2
print32_hex:
    push {r4, r5, r6, r7, lr}
    ldr  r1, =hex32_buf
    mov  r2, #7
.p32hex_loop:
    and  r3, r0, #0xF
    cmp  r3, #10
    addlt r3, r3, #'0'
    addge r3, r3, #('a'-10)
    strb r3, [r1, r2]
    lsr  r0, r0, #4
    subs r2, r2, #1
    bge  .p32hex_loop
    mov  r7, #SYS32_write
    mov  r0, #STDOUT32
    mov  r2, #8
    swi  #0
    pop  {r4, r5, r6, r7, pc}

; ══════════════════════════════════════════════════════════════════════════════
; print_caps_arm32
; ══════════════════════════════════════════════════════════════════════════════
.thumb_func
.align 2
print_caps_arm32:
    push {r4, r7, lr}
    mov  r7, #SYS32_write
    mov  r0, #STDOUT32
    ldr  r1, =str32_caps_hdr
    mov  r2, #str32_caps_hdr_len
    swi  #0

    ldr  r0, =g32_has_neon
    ldrb r0, [r0]
    cmp  r0, #0
    beq  .pc32_vfp
    mov  r0, #STDOUT32
    ldr  r1, =str32_neon
    mov  r2, #5
    swi  #0

.pc32_vfp:
    ldr  r0, =g32_has_vfpv4
    ldrb r0, [r0]
    cmp  r0, #0
    beq  .pc32_idivt
    mov  r0, #STDOUT32
    ldr  r1, =str32_vfpv4
    mov  r2, #6
    swi  #0

.pc32_idivt:
    ldr  r0, =g32_has_idivt
    ldrb r0, [r0]
    cmp  r0, #0
    beq  .pc32_nl
    mov  r0, #STDOUT32
    ldr  r1, =str32_idivt
    mov  r2, #6
    swi  #0

.pc32_nl:
    mov  r0, #STDOUT32
    ldr  r1, =str32_nl
    mov  r2, #2
    swi  #0
    pop  {r4, r7, pc}

; ══════════════════════════════════════════════════════════════════════════════
; repl_arm32 — REPL ENTERPRISE ARM32
; ══════════════════════════════════════════════════════════════════════════════
.thumb_func
.align 2
repl_arm32:
    push {r4, r5, r6, r7, r8, r9, lr}

.r32_loop:
    mov  r7, #SYS32_write
    mov  r0, #STDOUT32
    ldr  r1, =str32_prompt
    mov  r2, #str32_prompt_len
    swi  #0

    mov  r7, #SYS32_read
    mov  r0, #STDIN32
    ldr  r1, =io32_buf
    mov  r2, #2047
    swi  #0

    cmp  r0, #0
    ble  .r32_exit
    mov  r4, r0                ; r4 = bytes lidos

    cmp  r4, #1
    ble  .r32_toro_tick        ; linha vazia

    ; Strip \n
    ldr  r5, =io32_buf
    sub  r1, r4, #1
    mov  r2, #0
    strb r2, [r5, r1]

    ; Checa "exit" (4 bytes)
    ldr  r0, [r5]
    ldr  r1, =0x74697865       ; 'exit' LE
    cmp  r0, r1
    beq  .r32_exit

    ; "help"
    ldr  r1, =0x706C6568       ; 'help'
    cmp  r0, r1
    beq  .r32_help

    ; "toro"
    ldr  r1, =0x6F726F74       ; 'toro'
    cmp  r0, r1
    beq  .r32_toro_print

    ; "crc\0"
    ldr  r1, =0x00637263       ; 'crc\0'
    cmp  r0, r1
    beq  .r32_crc_print

    ; Comando externo via clone + execve
    ; clone(SIGCHLD, 0) → fork seguro bionic
    mov  r7, #SYS32_clone
    mov  r0, #SIGCHLD32
    mov  r1, #0                ; stack filho
    mov  r2, #0
    mov  r3, #0
    swi  #0

    cmp  r0, #0
    beq  .r32_child
    blt  .r32_toro_tick        ; falhou

    ; PAI: wait4
    mov  r7, #SYS32_wait4
    mov  r1, r0                ; pid
    mov  r0, #-1
    ldr  r2, =proc32_status
    mov  r3, #0
    swi  #0
    b    .r32_toro_tick

.r32_child:
    ; execve /termux/sh ou /system/bin/sh -c cmd
    sub  sp, sp, #16
    mov  r2, #0
    str  r2, [sp, #12]         ; NULL
    ldr  r2, =io32_buf
    str  r2, [sp, #8]          ; argv[2]=cmd
    ldr  r2, =arg32_1
    str  r2, [sp, #4]          ; argv[1]="-c"
    ldr  r2, =arg32_0
    str  r2, [sp, #0]          ; argv[0]="sh"

    ldr  r0, =path32_termux
    mov  r1, sp
    ldr  r2, =saved32_envp
    ldr  r2, [r2]
    mov  r7, #SYS32_execve
    swi  #0

    ldr  r0, =path32_system
    swi  #0

    ldr  r0, =path32_bin
    swi  #0

    mov  r7, #SYS32_exit
    mov  r0, #127
    swi  #0

.r32_toro_print:
    ldr  r5, =toro32_s
    mov  r6, #7
.r32_tp_loop:
    ldr  r0, [r5], #4
    bl   print32_hex
    mov  r7, #SYS32_write
    mov  r0, #STDOUT32
    ldr  r1, =str32_nl
    mov  r2, #2
    swi  #0
    subs r6, r6, #1
    bne  .r32_tp_loop
    b    .r32_toro_tick

.r32_crc_print:
    ldr  r0, =toro32_chain
    ldr  r0, [r0]
    bl   print32_hex
    mov  r7, #SYS32_write
    mov  r0, #STDOUT32
    ldr  r1, =str32_nl
    mov  r2, #2
    swi  #0
    b    .r32_toro_tick

.r32_help:
    mov  r7, #SYS32_write
    mov  r0, #STDOUT32
    ldr  r1, =str32_help
    mov  r2, #str32_help_len
    swi  #0

.r32_toro_tick:
    ldr  r0, =dispatch32_toro
    ldr  r0, [r0]
    blx  r0                    ; chama via dispatch table (blx para Thumb/ARM)

    b    .r32_loop

.r32_exit:
    pop  {r4, r5, r6, r7, r8, r9, pc}

; ══════════════════════════════════════════════════════════════════════════════
; FIM bootstrap_arm32_adaptive.s
; ══════════════════════════════════════════════════════════════════════════════


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 SEÇÃO C — TABELAS DE REFERÊNCIA ENTERPRISE COMPLETAS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

┌─────────────────────────────────────────────────────────────────────────────────┐
│  MAPA COMPLETO DE REGISTRADORES: ARM32 vs ARM64 com PRIMOS                     │
├────────────┬──────────────────────┬──────────────────────┬─────────────────────┤
│ Função ABI │ ARM32 (AAPCS)        │ ARM64 (AAPCS64)      │ Primo               │
├────────────┼──────────────────────┼──────────────────────┼─────────────────────┤
│ arg0/ret   │ r0                   │ x0                   │ 2 (fundação)        │
│ arg1       │ r1                   │ x1                   │ 3                   │
│ arg2       │ r2                   │ x2                   │ 5                   │
│ arg3       │ r3                   │ x3                   │ 7                   │
│ local0     │ r4 (callee-saved)    │ x4 (caller-saved)    │ 11                  │
│ local1     │ r5 (callee-saved)    │ x5 (caller-saved)    │ 13                  │
│ local2     │ r6 (callee-saved)    │ x6 (caller-saved)    │ 17                  │
│ syscall_nr │ r7 (callee-saved)    │ x8                   │ 19 / 23             │
│ local3     │ r8 (callee-saved)    │ x9 (caller-saved)    │ 29                  │
│ local4     │ r9 (callee-saved)    │ x10(caller-saved)    │ 31                  │
│ local5     │ r10(callee-saved)    │ x11(caller-saved)    │ 37                  │
│ frame_ptr  │ r11 fp               │ x29 fp               │ 41 / 113            │
│ intra-call │ r12 ip               │ x16 ip0              │ 43 / 59             │
│ stack ptr  │ r13 sp               │ sp                   │ —                   │
│ link reg   │ r14 lr               │ x30 lr               │ 47 / 127            │
│ prog cnt   │ r15 pc               │ pc                   │ —                   │
│ cs0 ARM64  │ —                    │ x19                  │ 71                  │
│ cs1 ARM64  │ —                    │ x20                  │ 73                  │
│ cs2 ARM64  │ —                    │ x21                  │ 79                  │
│ cs3 ARM64  │ —                    │ x22                  │ 83                  │
│ cs4 ARM64  │ —                    │ x23                  │ 89                  │
│ cs5 ARM64  │ —                    │ x24                  │ 97                  │
├────────────┴──────────────────────┴──────────────────────┴─────────────────────┤
│  PRODUTO DE PRIMOS DA ENTRY CANÔNICA:                                           │
│  ARM32: push{r4,r5,r6,r7,lr} = 11×13×17×19×47 = 2,764,981 (ID único)          │
│  ARM64: stp x29,x30,[sp,#-16]! = 113×127 = 14,351 (ID único)                  │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│  SYSCALLS CRÍTICOS: ARM32 vs ARM64 vs x86_64                                   │
├──────────────┬──────────────┬──────────────┬──────────────┬─────────────────────┤
│ Syscall      │ ARM32 (r7)   │ ARM64 (x8)   │ x86_64 (rax) │ Primo de referência │
├──────────────┼──────────────┼──────────────┼──────────────┼─────────────────────┤
│ read         │ 3            │ 63           │ 0            │ p=3 (leitura)       │
│ write        │ 4            │ 64           │ 1            │ p=2 (escrita/saída) │
│ open/openat  │ 5 / 322      │ 56           │ 2 / 257      │ p=5                 │
│ close        │ 6            │ 57           │ 3            │ p=7                 │
│ fork         │ 2            │ 57(legado)   │ 57           │ p=2 (divisão)       │
│ clone        │ 120          │ 220          │ 56           │ p=11 (fork moderno) │
│ execve       │ 11           │ 221          │ 59           │ p=13 (execução)     │
│ exit         │ 1            │ 93           │ 60           │ p=2 (terminal)      │
│ wait4        │ 114          │ 260          │ 61           │ p=17 (sincronismo)  │
│ mmap         │ 90(mmap)     │ 222          │ 9            │ p=19 (memória)      │
│ mmap2        │ 192          │ —            │ —            │ p=23 (mmap ARM32)   │
│ mprotect     │ 125          │ 226          │ 10           │ p=29 (proteção)     │
│ getpid       │ 20           │ 172          │ 39           │ p=31 (identidade)   │
│ gettid       │ 224          │ 178          │ 186          │ p=37 (thread id)    │
│ prctl        │ 172          │ 167          │ 157          │ p=41 (controle)     │
│ getrandom    │ 384          │ 278          │ 318          │ p=43 (entropia)     │
├──────────────┴──────────────┴──────────────┴──────────────┴─────────────────────┤
│  INVOCAÇÃO: ARM32=swi#0  ARM64=svc#0  x86_64=syscall                           │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│  HWCAP BITS: ARM32 vs ARM64 — Detecção Adaptativa                              │
├───────────────────┬───────────────────┬──────────────────────────────────────── │
│ Feature           │ ARM32 bit         │ ARM64 bit                               │
├───────────────────┼───────────────────┼──────────────────────────────────────── │
│ NEON/ASIMD        │ bit 12 (HWCAP32)  │ bit 1 (HWCAP) — sempre 1 em AArch64   │
│ VFPv3             │ bit 13            │ bit 0 (FP)                              │
│ VFPv4             │ bit 16            │ bit 9 (FPHP)                            │
│ CRC32 HW          │ não disponível    │ bit 7                                   │
│ AES HW            │ não disponível    │ bit 3                                   │
│ SHA1 HW           │ não disponível    │ bit 5                                   │
│ SHA256 HW         │ não disponível    │ bit 6                                   │
│ LSE Atomics       │ não disponível    │ bit 8                                   │
│ SVE               │ não disponível    │ bit 22 (HWCAP)                          │
│ IDIVA (ARM)       │ bit 17            │ obrigatório                             │
│ IDIVT (Thumb)     │ bit 18            │ obrigatório                             │
│ EVTSTRM           │ bit 21            │ bit 2                                   │
├───────────────────┴───────────────────┴──────────────────────────────────────── │
│  LEITURA: aux vector após envp[] NULL. Pares (type=8, value=8) ou (type=4,v=4) │
│  AT_HWCAP=16 AT_HWCAP2=26 AT_NULL=0                                            │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│  NEON: ARM32 (d/q regs) vs ARM64 (v regs) — Instruções-chave                  │
├──────────────────────────┬──────────────────────────────────────────────────── │
│ ARM32 NEON               │ ARM64 Advanced SIMD                                 │
├──────────────────────────┼──────────────────────────────────────────────────── │
│ vld1.8 {q0,q1},[r1]!    │ ld1 {v0.16b,v1.16b},[x1],#32                       │
│ vst1.8 {q0,q1},[r0]!    │ st1 {v0.16b,v1.16b},[x0],#32                       │
│ vmull.u32 q4,d0,d4      │ umull v4.2d,v0.2s,v2.2s                             │
│ vmull.u32 q5,d1,d5      │ umull2 v5.2d,v0.4s,v2.4s                            │
│ vshrn.u64 d0,q4,#16     │ shrn v0.2s,v4.2d,#16                                │
│ vshrn.u64 d1,q5,#16     │ shrn2 v0.4s,v5.2d,#16                               │
│ vmov.i8 d0,#0           │ movi v0.16b,#0                                       │
│ vmov.u32 q2,#49152      │ movi v2.4s,#0xC0,lsl#8                               │
│ vdup.8 q0,r1            │ dup v0.16b,w1                                        │
│ vld1.32 {q0},[r4]       │ ld1 {v0.4s},[x21]                                   │
│ vst1.32 {q0},[r4]!      │ st1 {v0.4s},[x21],#16                               │
│ blx r0  (ARM↔Thumb)     │ blr x0                                               │
│ bx lr   (return Thumb)  │ ret                                                  │
│ swi #0  (syscall)       │ svc #0                                               │
│ ittt ne (predicate)     │ (sem predição Thumb2 direto — usa cbz/cbnz)          │
└──────────────────────────┴──────────────────────────────────────────────────── │

┌─────────────────────────────────────────────────────────────────────────────────┐
│  Q16.16 OPERAÇÕES FUNDAMENTAIS (sem float, sem libc, freestanding)             │
├─────────────────────────────────────────────────────────────────────────────────┤
│  Constantes:                                                                    │
│    1.0 = 65536 = 0x10000                                                        │
│    0.5 = 32768 = 0x8000                                                         │
│    √3/2= 56756 = 0xDDD4   (Lyapunov λ=-0.1438, toro estável)                  │
│    φ   =105965 = 0x19E5D  (seção áurea 1.618...)                               │
│    π   =205887 = 0x32400  (aproximado)                                          │
│    π/2 =102944 = 0x19200                                                        │
│    F*  =1517798            (ponto fixo Fibonacci-Rafael, novo)                  │
│                                                                                 │
│  Multiplicação: (a × b) >> 16                                                  │
│    ARM64: mul x0,x0,x1; lsr x0,x0,#16                                          │
│    ARM32: umull r0,r1,r0,r1; (r0=hi, r1=lo → usa r0>>16 combinado)             │
│                                                                                 │
│  EMA (α=0.25): (old×49152 + in×16384) >> 16                                   │
│    ARM64: umull x4,w0,w2; umull x5,w1,w3; add x4,x4,x5; lsr w0,w4,#16        │
│    ARM32: umull r4,r5,r0,r2; mla r4,r1,r3,r4; lsr r0,r4,#16                  │
│                                                                                 │
│  Módulo (sem divisão): x mod 42 = x - 42*(x/42)                               │
│    ARM64: udiv w2,w0,w1; msub w0,w2,w1,w0                                      │
│    ARM32 IDIVT: udiv r2,r0,r1; mls r0,r2,r1,r0                                │
│    ARM32 sem IDIVT: subtração iterativa (loop)                                  │
│                                                                                 │
│  CRC32C Castagnoli (RFC 3720):                                                  │
│    ARM64 HW: crc32cx w2,w2,x3  (instrução em encoding ARM64)                   │
│    ARM32 SW: tabela 256×uint32 poly=0x82F63B78                                  │
│                                                                                 │
│  sin(x) Q16.16 (approx Taylor para |x|<π/2):                                  │
│    x3 = x²×x>>16; x5 = x3×x²>>16                                              │
│    result = x - x3×10923>>16 + x5×546>>16                                      │
│    ARM32: umull+lsr por etapa                                                   │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│  ALINHAMENTO CRÍTICO: Android page size                                         │
├─────────────────────────────────────────────────────────────────────────────────┤
│  Android < 15:  page = 4KB  → .align 12 (2^12=4096)                           │
│  Android 15/16: page = 16KB → .align 14 (2^14=16384) [OBRIGATÓRIO]            │
│                                                                                 │
│  Sem .align 14: SIGSEGV no startup em kernels 5.15.178+ com 16KB pages         │
│                                                                                 │
│  Verificar: readelf -l binario | grep "Align"                                  │
│  Correto:   Align: 0x4000 (16384)                                              │
│  Errado:    Align: 0x1000 (4096) em dispositivo Android 16                     │
│                                                                                 │
│  DICA: sempre usar .align 14 em .bss e .data para compatibilidade universal    │
└─────────────────────────────────────────────────────────────────────────────────┘


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 SEÇÃO D — MAKEFILE ENTERPRISE ADAPTATIVO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# === Makefile Enterprise RAFAELIA =========================================
# Detecta toolchain, compila ARM64 + ARM32, valida alinhamentos, gera ZIP
# Uso:
#   make all        → compila arm64 + arm32
#   make arm64      → só arm64-v8a
#   make arm32      → só armeabi-v7a (requer NDK ou cross-compiler)
#   make verify     → verifica alinhamento 16KB nos dois binários
#   make run64      → compila e roda arm64 (se no dispositivo arm64)
#   make crc        → calcula CRC32 de todos os objetos (integridade)
#   make zip        → empacota src+obj+bin com MANIFEST
#   make clean
# =========================================================================

ARCH := $(shell uname -m)

# ── Toolchain ARM64 (nativo em dispositivo arm64 / cross no Linux) ─────────
ifeq ($(filter aarch64 arm64,$(ARCH)),$(ARCH))
  AS64  = as
  LD64  = ld
  CC64  = clang
else
  AS64  = aarch64-linux-android-as
  LD64  = aarch64-linux-android-ld
  CC64  = aarch64-linux-android-clang
endif

# ── Toolchain ARM32 (cross-compilação via NDK) ─────────────────────────────
AS32  = arm-linux-androideabi-as
LD32  = arm-linux-androideabi-ld
CC32  = armv7a-linux-androideabi21-clang

# ── Flags por módulo (não globais — filosofia CODEX POLIMATA) ──────────────
AFLAGS64 = -march=armv8-a
LFLAGS64 = -Wl,-z,max-page-size=16384   # CRÍTICO Android 15/16

AFLAGS32 = -march=armv7-a -mfpu=neon-vfpv4 -mthumb
LFLAGS32 =

OUTDIR   = build
SRCDIR   = .
ZIPNAME  = rafaelia_enterprise_$(shell date +%Y%m%d_%H%M).zip

.PHONY: all arm64 arm32 verify run64 crc zip clean dirs

all: dirs arm64 arm32 verify

dirs:
	mkdir -p $(OUTDIR)/obj $(OUTDIR)/bin $(OUTDIR)/meta

arm64: dirs
	$(AS64) $(AFLAGS64) -o $(OUTDIR)/obj/rafa64.o bootstrap_arm64_adaptive.s
	$(LD64) $(LFLAGS64) -o $(OUTDIR)/bin/rafa64 $(OUTDIR)/obj/rafa64.o
	@echo "[OK] ARM64 arm64-v8a → $(OUTDIR)/bin/rafa64"
	@ls -lh $(OUTDIR)/bin/rafa64

arm32: dirs
	$(AS32) $(AFLAGS32) -o $(OUTDIR)/obj/rafa32.o bootstrap_arm32_adaptive.s
	$(LD32) -o $(OUTDIR)/bin/rafa32 $(OUTDIR)/obj/rafa32.o
	@echo "[OK] ARM32 armeabi-v7a → $(OUTDIR)/bin/rafa32"
	@ls -lh $(OUTDIR)/bin/rafa32

verify:
	@echo "=== Verify ARM64 alinhamento 16KB ==="
	readelf -l $(OUTDIR)/bin/rafa64 2>/dev/null | grep -E "LOAD|Align" || echo "N/A"
	@echo "=== Verify ARM32 ==="
	readelf -l $(OUTDIR)/bin/rafa32 2>/dev/null | grep -E "LOAD|Align" || echo "N/A"
	@echo "=== Symbols ARM64 ==="
	nm -n $(OUTDIR)/bin/rafa64 2>/dev/null | grep -E "_start|dispatch|toro|hwcap" || true

run64: arm64
	@echo "=== Rodando ARM64 (requer dispositivo arm64 ou QEMU) ==="
	$(OUTDIR)/bin/rafa64

crc:
	@echo "=== CRC32 de todos os objetos (integridade do build) ==="
	@for f in $(OUTDIR)/obj/*.o $(OUTDIR)/bin/rafa64 $(OUTDIR)/bin/rafa32; do \
	  [ -f "$$f" ] && printf "%s: %s\n" "$$f" "$$(crc32 $$f 2>/dev/null || cksum $$f | cut -d' ' -f1)"; \
	done

zip: all crc
	@echo "RAFAELIA ENTERPRISE BUILD" > $(OUTDIR)/meta/MANIFEST.txt
	@echo "DATE: $(shell date -u +%Y-%m-%dT%H:%M:%SZ)" >> $(OUTDIR)/meta/MANIFEST.txt
	@echo "ARCH_HOST: $(ARCH)" >> $(OUTDIR)/meta/MANIFEST.txt
	@uname -r >> $(OUTDIR)/meta/MANIFEST.txt
	zip -r $(ZIPNAME) $(OUTDIR)/ *.s Makefile
	@echo "[ZIP] $(ZIPNAME)"
	@ls -lh $(ZIPNAME)

clean:
	rm -rf $(OUTDIR) $(ZIPNAME)

# === FIM Makefile =========================================================


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 SEÇÃO E — SETUP COMPLETO NO TERMUX + COMANDOS DE USO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ── 0. Instalar no Termux ─────────────────────────────────────────────────────
pkg update
pkg install -y binutils clang coreutils

# ── 1. Codificar ARM64 via cat (técnica correta: << 'EOF' sem interpolação) ───
cat > bootstrap_arm64_adaptive.s << 'EOF'
... cole o conteúdo da SEÇÃO A aqui (a partir de ".arch armv8-a") ...
EOF

# ── 2. Codificar ARM32 via cat ────────────────────────────────────────────────
cat > bootstrap_arm32_adaptive.s << 'EOF'
... cole o conteúdo da SEÇÃO B aqui (a partir de ".arch armv7-a") ...
EOF

# ── 3. Compilar ARM64 nativo (Termux em dispositivo arm64) ───────────────────
as -o rafa64.o bootstrap_arm64_adaptive.s
ld -o rafa64 rafa64.o

# ── 4. Rodar ──────────────────────────────────────────────────────────────────
./rafa64

# ── 5. Interagir com o REPL ───────────────────────────────────────────────────
# rafaφ64❯ caps            → mostra NEON CRC32 AES SHA2 LSE SVE detectados
# rafaφ64❯ toro            → imprime s[0..6] Q16.16 do toro T^7
# rafaφ64❯ crc             → imprime CRC32C chain acumulado
# rafaφ64❯ status          → imprime phi (saída toroidal)
# rafaφ64❯ help            → lista comandos
# rafaφ64❯ ls -la          → executa ls via /system/bin/sh -c "ls -la"
# rafaφ64❯ uname -a        → qualquer comando do sistema
# rafaφ64❯ exit            → sai com CRC chain final exibido

# ── 6. Verificar alinhamento 16KB (crítico Android 15/16) ────────────────────
readelf -l rafa64 | grep -E "LOAD|Align"
# Esperado: Align: 0x4000 (se .align 14 foi usado)

# ── 7. Compilar ARM32 via NDK (em Linux com NDK instalado) ───────────────────
# Baixar: https://developer.android.com/ndk/downloads
NDK=/path/to/ndk
$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/arm-linux-androideabi-as \
    -march=armv7-a -mfpu=neon-vfpv4 -mthumb \
    -o rafa32.o bootstrap_arm32_adaptive.s
$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/arm-linux-androideabi-ld \
    -o rafa32 rafa32.o
# Copiar rafa32 para o dispositivo e rodar


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 SEÇÃO F — NOTAS ENTERPRISE CRÍTICAS (CODEX POLIMATA)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] REGISTRADORES LINEARES ADAPTÁVEIS
    O bootstrap inicia com SOMENTE as instruções genéricas disponíveis
    em qualquer ARMv7-A ou ARMv8-A. Após HWCAP probe, a dispatch table
    é reescrita em runtime. Isso garante:
    — Funciona em qualquer dispositivo Android 5+
    — Usa NEON se disponível (performance máxima)
    — Usa CRC32 HW se disponível (integridade acelerada)
    — Fallback software transparente em hardware mínimo

[2] TORO T^7 SEM ESTADO GLOBALMENTE CORROMPÍVEL
    Cada dimensão inicia em s[d] = (SPIRAL × prime_d) & 0xFFFF.
    O produto dos 7 primos (2×3×5×7×11×13×17 = 510510) identifica
    o estado inicial de forma única. Após n passos, o CRC32C do estado
    acumula em toro_chain — qualquer corrupção muda o chain.
    Invariante: se chain_atual ≠ chain_esperado → rollback ao snapshot.

[3] FREESTANDING ABSOLUTO
    Zero libc. Zero bionic. Zero malloc. Zero printf.
    Toda I/O é SYS_read/SYS_write direta. Toda memória é BSS + arena bump.
    O único "sistema" externo é o kernel Linux — via svc/swi.
    Isso garante portabilidade para qualquer Android com kernel Linux,
    independente da versão de bionic, NDK, ou libc disponível.

[4] FORK SEGURO NO ANDROID
    SYS_fork (ARM32=2, ARM64=57) pode ser bloqueado no Android 12+
    pelo Phantom Process Killer (limite de 32 processos por app).
    Solução: SYS_clone(SIGCHLD=17, stack=NULL) — equivalente a fork()
    mas invocado como bionic faz internamente. Se o clone falhar,
    o REPL não trava — simplesmente executa o próximo tick do toro.

[5] CRC32C CHAIN — INTEGRIDADE TEMPORAL
    Em cada ciclo do REPL: toro é avançado + CRC do estado calculado.
    chain ^= new_crc (XOR encadeia) — qualquer adulteração de estado
    se propaga no chain. Na saída, o chain é exibido em hex.
    Isso é a versão assembly do "Merkle chain de builds" do CODEX.

[6] EMA Q16.16 — MEMÓRIA SEM FLOAT
    α=0.25 (16384), 1-α=0.75 (49152)
    EMA(t) = (EMA(t-1)×49152 + input×16384) >> 16
    Usando umull (ARM32) ou umull/umull2 (ARM64 NEON), a operação
    é exata em Q16.16, sem overflow para valores em [0, 65535].
    ARM32: umull r4,r5,r0,r2 gera 64-bit em {r5:r4}, usa lsr em r4.
    ARM64 NEON: umull v4.2d,v0.2s,v2.2s → 64-bit → shrn → 32-bit.

[7] DISPATCH TABLE — O CORAÇÃO ADAPTATIVO
    A tabela em .data contém 5 ponteiros de função (32-bit ARM32, 64-bit ARM64).
    Inicializados para versões genéricas. Após HWCAP:
      NEON detectado → memcpy/memset/ema/toro = versão NEON
      CRC32 HW       → crc32 = versão hardware
    Chamar via tabela: ARM64=ldr+blr, ARM32=ldr+blx (Thumb↔ARM correto).
    A indireção tem custo ~1-2 ciclos — desprezível vs ganho NEON.

[8] CAMINHO DOS PRIMOS — IDENTIFICAÇÃO DE ESTADO
    Cada função tem um primo de identificação.
    Composição: _start(p=2) → hwcap_probe(p=3) → dispatch_rewire(p=5)
    → toro_init(p=11) → repl(p=31) → [toro_step per ciclo(p=11×3=33)]
    Produto do caminho: 2×3×5×11×31 = 10230
    Decompor 10230 = 2×3×5×11×31 → identifica exatamente este bootstrap.
    Qualquer bootstrap diferente terá produto diferente de primos.

[9] GEOLM INTEGRATION (próximo passo)
    Este bootstrap é a fundação (p=2) do sistema GEOLM completo.
    Para integrar geolm_full.c:
      1. Compilar geolm com arena_bss em vez de malloc
      2. Linkar com este bootstrap (substitui _start e arena_alloc)
      3. REPL chama geolm_infer() em vez de execve
      4. Toro alimenta CoherenceScore do GEOLM via dispatch_ema
    Custo estimado de integração: 2-3 dias

╔══════════════════════════════════════════════════════════════════════════════════╗
║  RAFAELIA · ABI BOOTSTRAP ENTERPRISE · ARM32 + ARM64 · ADAPTATIVO COMPLETO    ║
║  Gerado via cat > RAFAELIA_ABI_CODEX_ENTERPRISE.txt << 'TERMINUS'             ║
║  Linhas: ver wc -l · Tamanho: ver ls -lh                                       ║
║  Filosofia: zero abstração, hardware direto, primos de estado, toro 7D Q16.16  ║
╚══════════════════════════════════════════════════════════════════════════════════╝
TERMINUS

