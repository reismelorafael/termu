/*
 * bootstrap_arm64_adaptive.S
 * Clean promotion draft from bootstrap_ref reference.
 * Intentionally NOT wired into CMake/Gradle yet.
 */

.arch armv8-a
.text
.align 2

.global _start
.global hwcap_probe_arm64
.global dispatch_rewire_arm64
.global init_crc_table_arm64
.global toro_step_arm64
.global repl_arm64

/* Linux AArch64 syscalls */
.equ SYS_exit, 93

_start:
    bl hwcap_probe_arm64
    bl dispatch_rewire_arm64
    bl init_crc_table_arm64
    bl toro_step_arm64
    bl repl_arm64
    mov x0, #0
    mov x8, #SYS_exit
    svc #0

hwcap_probe_arm64:
    ret

dispatch_rewire_arm64:
    ret

init_crc_table_arm64:
    ret

toro_step_arm64:
    ret

repl_arm64:
    ret
